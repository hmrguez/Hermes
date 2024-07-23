import json
import random
import time

from confluent_kafka import Producer


# Example financial transaction data
def generate_transaction():
    transaction = {
        "transaction_id": random.randint(1000, 9999),
        "timestamp": int(time.time()),
        "amount": round(random.uniform(10.0, 500.0), 2),
        "currency": random.choice(["USD", "EUR", "GBP"]),
        "sender": f"user{random.randint(1, 100)}",
        "receiver": f"user{random.randint(1, 100)}",
        "location": random.choice(["New York", "London", "Berlin", "Tokyo"])
    }
    return transaction


# Function to send data to Kafka
def send_data_to_kafka(producer: Producer, topic: str, data):
    producer.produce(topic, value=json.dumps(data))
    producer.flush()


if __name__ == "__main__":

    # Kafka topic
    topic = 'financial_transactions'

    # Kafka configuration
    kafka_conf = {
        'bootstrap.servers': 'localhost:9092',  # Adjust this to your Kafka server
        'client.id': 'financial-transactions-producer'
    }

    producer = Producer(kafka_conf)

    # Produce messages to Kafka topic
    try:
        while True:
            transaction = generate_transaction()
            print(f'Sending transaction: {transaction}')
            send_data_to_kafka(producer, topic, transaction)
            time.sleep(1)  # Adjust the sleep time as needed for your use case
    except KeyboardInterrupt:
        print('Stopped producing messages.')
