#!/usr/bin/python3
import urllib.request
import sys

def main():
    urls = [x for x in sys.argv[1:]]
    print('go')
    print(urls)
    print('end')
    print(len(urls))
    for i,url in enumerate(urls[:-1]):
        urllib.request.urlretrieve(url, "fsm{:02d}.png".format(i+1))


if __name__ == '__main__':
    main()
