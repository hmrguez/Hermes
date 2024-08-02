import random

import pymongo
from faker import Faker

# Create a connection to MongoDB
client = pymongo.MongoClient("mongodb://localhost:27017/")

# Access the database named 'hermes'
db = client['hermes']

# Access the collections
users_collection = db['users']
ride_requests_collection = db['ride_requests']

# Create an instance of the Faker class
fake = Faker()


# Function to generate fake ride request data
def generate_fake_ride_request(rider_id):
    ride_request = {
        "riderId": rider_id,
        "pickupLocation": fake.address(),
        "requestId": fake.uuid4()
    }
    return ride_request


# Retrieve all existing user_ids from the users collection
user_ids = [user['user_id'] for user in users_collection.find({}, {"user_id": 1, "_id": 0})]

# Number of fake ride requests to generate
num_ride_requests = 200

# Generate and insert fake ride requests into the 'ride_requests' collection
for _ in range(num_ride_requests):
    rider_id = random.choice(user_ids)
    fake_ride_request = generate_fake_ride_request(rider_id)
    ride_requests_collection.insert_one(fake_ride_request)

print(f"Inserted {num_ride_requests} fake ride requests into the 'ride_requests' collection in the 'hermes' database.")
