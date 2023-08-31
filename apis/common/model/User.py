
class User():
    email: str
    password: str
    create_at: str
    update_at: str
    
    def __init__(self, email: str, password: str, created_at: str, updated_at: str):
        self.email = email
        self.password = password
        self.created_at = created_at
        self.updated_at = updated_at
