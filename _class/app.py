from secret_libs.secret import Secret

class MainThread:

    def __init__(self):
        self.something = Secret()
    
    def exec(self):
        print(self.something)