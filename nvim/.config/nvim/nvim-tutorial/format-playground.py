def greet(name: str,count: int)->str:
    message=f"hello {name}"
    for index in range(count): print(index,message)
    return message
