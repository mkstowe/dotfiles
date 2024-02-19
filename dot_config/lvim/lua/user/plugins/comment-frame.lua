return {
  's1n7ax/nvim-comment-frame',
  dependencies = {
    'nvim-treesitter',
  },
  config = function()
    require('nvim-comment-frame').setup {
      keymap = '<leader>cc',
      multiline_keymap = '<leader>C'
    }
  end
}
