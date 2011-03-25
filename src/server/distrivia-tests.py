#!/usr/bin/env python
import distrivia
import unittest
import riak


class DistriviaTestCase(unittest.TestCase):

    def setUp(self):
        self.app = distrivia.app.test_client()
        self.err = distrivia.API_ERROR
        self.suc = distrivia.API_SUCCESS
        self.clearBucket("users")

    def tearDown(self):
        self.clearBucket("users")

    # Helper functions

    def clearBucket(self, bucketName):
        client = riak.RiakClient()
        bucket = client.bucket(bucketName)
        for key in bucket.get_keys():
            bucket.get(key).delete()

    def register(self, username):
            """Helper function to register a user"""
            return self.app.post('/register/'+username,
            follow_redirects=True)

    def login(self, username):
        """Helper function to login"""
        return self.app.post('/login/'+username,
        follow_redirects=True)


    def test_register(self):
        """ Make sure registration works """
        # Registering should work the first time
        rv = self.register("brian")
        assert self.suc == rv.data
        # Registering again with the same name should fail
        rv = self.register("brian")
        assert self.err == rv.data

    def test_login(self):
        """ Make sure login works """
        self.register("brian")
        rv = self.login("brian")
        assert self.err != rv.data



    # Test cases

if __name__ == '__main__':
    unittest.main()

