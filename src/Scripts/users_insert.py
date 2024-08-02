import random

import pymongo
from faker import Faker

# Create a connection to MongoDB
client = pymongo.MongoClient("mongodb://localhost:27017/")

# Access the database named 'hermes'
db = client['hermes']

# Access the collection named 'users'
users_collection = db['users']

# Create an instance of the Faker class
fake = Faker()


# Function to generate fake user data
def generate_fake_user():
    user = {
        "user_id": fake.uuid4(),
        "name": fake.name(),
        "age": random.randint(18, 80),
        "gender": random.choice(["Male", "Female", "Other"])
    }
    return user


# Number of fake users to generate
num_users = 100

# Generate and insert fake users into the 'users' collection
for _ in range(num_users):
    fake_user = generate_fake_user()
    users_collection.insert_one(fake_user)

print(f"Inserted {num_users} fake users into the 'users' collection in the 'hermes' database.")
