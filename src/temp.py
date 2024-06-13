import os


def temp():
    if os.path.exists("dasdas"):
        print("Do something")
    else:
        print("Do nothing")


if __name__ == "__main__":
    temp()
