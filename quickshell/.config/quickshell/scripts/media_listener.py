#!/usr/bin/env python3
import argparse
import json
import logging
import os
import signal
import sys
from typing import List, Optional

import gi

gi.require_version("Playerctl", "2.0")
from gi.repository import GLib, Playerctl
from gi.repository.Playerctl import Player

logger = logging.getLogger(__name__)


def signal_handler(sig, frame):
    sys.stdout.write("\n")
    sys.stdout.flush()
    sys.exit(0)


class PlayerManager:
    def __init__(self, selected_player: Optional[str] = None):
        self.manager = Playerctl.PlayerManager()
        self.loop = GLib.MainLoop()
        self.selected_player = selected_player

        self.manager.connect("name-appeared", self.on_player_appeared)
        self.manager.connect("player-vanished", self.on_player_vanished)

        signal.signal(signal.SIGINT, signal_handler)
        signal.signal(signal.SIGTERM, signal_handler)
        signal.signal(signal.SIGPIPE, signal.SIG_DFL)

        self.init_players()

    def init_players(self):
        for player_name in self.manager.props.player_names:
            if self.selected_player is not None and self.selected_player != player_name.name:
                continue
            self.init_player(player_name)

    def run(self):
        self.emit_current_state()
        self.loop.run()

    def init_player(self, player_name):
        player = Player.new_from_name(player_name)
        player.connect("playback-status", self.on_playback_status_changed, None)
        player.connect("metadata", self.on_metadata_changed, None)
        self.manager.manage_player(player)
        self.on_metadata_changed(player, player.props.metadata)

    def get_players(self) -> List[Player]:
        return list(self.manager.props.players)

    def get_first_playing_player(self) -> Optional[Player]:
        players = self.get_players()
        if len(players) > 0:
            for player in players[::-1]:
                if player.props.status == "Playing":
                    return player
            return players[0]
        return None

    def emit_payload(self, payload):
        sys.stdout.write(json.dumps(payload) + "\n")
        sys.stdout.flush()

    def clear_output(self):
        self.emit_payload({
            "hasPlayer": False,
            "isPlaying": False,
            "playerName": "",
            "artist": "",
            "title": "",
            "text": "-",
        })

    def build_payload(self, player, metadata):
        player_name = player.props.player_name or ""
        artist = player.get_artist() or ""
        title = player.get_title() or ""
        is_playing = player.props.status == "Playing"

        if (
            player_name == "spotify"
            and "mpris:trackid" in metadata.keys()
            and ":ad:" in str(player.props.metadata["mpris:trackid"])
        ):
            artist = ""
            title = "Advertisement"

        if artist and title:
            text = f"{artist} — {title}"
        elif title:
            text = title
        else:
            text = "-"

        return {
            "hasPlayer": True,
            "isPlaying": is_playing,
            "playerName": player_name,
            "artist": artist,
            "title": title,
            "text": text,
        }

    def emit_current_state(self):
        current_player = self.get_first_playing_player()
        if current_player is None:
            self.clear_output()
            return

        self.emit_payload(self.build_payload(current_player, current_player.props.metadata))

    def on_playback_status_changed(self, player, status, _=None):
        self.on_metadata_changed(player, player.props.metadata)

    def on_metadata_changed(self, player, metadata, _=None):
        current_player = self.get_first_playing_player()
        if current_player is None:
            self.clear_output()
            return

        if current_player.props.player_name == player.props.player_name:
            self.emit_payload(self.build_payload(player, metadata))

    def on_player_appeared(self, _, player_name):
        if player_name is not None and (
            self.selected_player is None or player_name.name == self.selected_player
        ):
            self.init_player(player_name)

    def on_player_vanished(self, _, player):
        self.emit_current_state()


def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("--player")
    parser.add_argument("--enable-logging", action="store_true")
    parser.add_argument("-v", "--verbose", action="count", default=0)
    return parser.parse_args()


def main():
        args = parse_arguments()

        if args.enable_logging:
            logfile = os.path.join(
                os.path.dirname(os.path.realpath(__file__)),
                "media-player.log",
            )
            logging.basicConfig(
                filename=logfile,
                level=logging.DEBUG,
                format="%(asctime)s %(name)s %(levelname)s:%(lineno)d %(message)s",
            )

        logger.setLevel(max((3 - args.verbose) * 10, 0))

        manager = PlayerManager(args.player)
        manager.run()


if __name__ == "__main__":
    main()