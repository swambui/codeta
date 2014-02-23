from passlib.context import CryptContext

"""
    Set up crypto for storing passwords in the database
"""

pass_context = CryptContext(
    # use bcrypt for password hashes
    schemes = ['bcrypt_sha256'],
    default = 'bcrypt_sha256',

    all__vary_rounds = 0.1,

    bcrypt_sha256__default_rounds = 13,
    )

class Auth(object):
    def __init__(self, crypt_context=None):
        """ Handles encrypting and decrypting passwords """
        if crypt_context:
            self.crypt_context = crypt_context
        else:
            self.crypt_context = pass_context

    def check_password(self, password, pw_hash):
        """
            Verifies the password matches the hash.
            Returns True if match, otherwise False.
        """

        rc = self.crypt_context.verify(password, pw_hash)

        return rc

    def hash_password(self, password):
        """
            Hashes a password.
            If password meets specification, returns the
            hash as a string, otherwise return None.
        """

        rc = self.crypt_context.encrypt(password)

        return rc
