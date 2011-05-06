#!/usr/bin/env python
import httplib
import urllib
import json
import random
import time
from multiprocessing import Process
import thread

mutex = thread.allocate_lock()
count = 0

def inc():
    global count
    mutex.acquire()
    count += 1
    mutex.release()

class Callable:
    def __init__(self, anycallable):
        self.__call__ = anycallable

class DistriviaAPI:

    def register(user,passwd):
        url = "/register/"+user
        post = { "password": passwd }
        data = DistriviaAPI.postData(url, post)
        return data == "suc"

    register = Callable(register)

    def login(user,passwd):
        url = "/login/"+user
        post = { "password": passwd }
        data = DistriviaAPI.postData(url, post)
        return data

    login = Callable(login)

    def join(user, token):
        url = "/public/join"
        post = { "authToken": token, "user": user }
        data = DistriviaAPI.postData(url,post)
        jdata = json.loads(data)
        return jdata

    join = Callable(join)

    def status(token,gid):
        url = "/game/"+gid
        post = { "authToken": token }
        data = DistriviaAPI.postData(url,post)
        jdata = json.loads(data)
        return jdata

    status = Callable(status)

    def answer(token, gid, qid, user, time, answer):
        url = "/game/"+gid+"/question/"+qid
        post = { "authToken": token, "user":user, "time":time, "a":answer}
        data = DistriviaAPI.postData(url,post)
        jdata = json.loads(data)
        return jdata

    answer = Callable(answer)

    def postData(urlFrag, paramData):
        _headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
        params = urllib.urlencode(paramData)
        conn = httplib.HTTPSConnection("distrivia.lame.ws:443")
        conn.request("POST", urlFrag, params, _headers)
        response = conn.getresponse()
        data = response.read()
        conn.close()
        return data

    postData = Callable(postData)


def ranswer():
    """ Choose a random answer to the question """
    choices = [ "a", "b", "c", "d" ]
    choice = choices[random.randint(0,3)]
    return choice


def rtime():
    return random.randint(200,1000)


def playgame(name,token):
    jdata = DistriviaAPI.join(name,token)

    gid = jdata["id"]

    print name + " joined game: " + gid

    # Wait until game starts
    status = DistriviaAPI.status(token, gid)
    while status["gamestatus"] != "started":
        status = DistriviaAPI.status(token, gid)
        print name + " waiting"
        time.sleep( 20 )

    gdata = status
    while True:
        if gdata["gamestatus"]  == "done":
            break

        qid = gdata["qid"]
        ans = ranswer()
        tim = rtime()
        gdata = DistriviaAPI.answer(token, gid, qid, name, tim, ans)

        print name + " answered: " + ans
        inc()


def botmain():
    name = "autobot-"+str(random.randint(0,9999999))
    passwd = "mmm-bits"




    DistriviaAPI.register(name,passwd)
    token = DistriviaAPI.login(name,passwd)

    while True:
        tmp = count
        start = time.clock()
        playgame(name, token)
        print "Stats: %s req/s" % str( float( count-tmp ) / float( time.clock() -
        start))

if __name__ == "__main__":
    for proc in range(10):
        Process(target=botmain).start()
