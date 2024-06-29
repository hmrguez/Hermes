import json
import random
import time

from faker import Faker
from confluent_kafka import SerializingProducer
from datetime import datetime

fake = Faker()


def generate_sales_transactions():
    user = fake.simple_profile()

    return {
        "transaction_id": fake.uuid4(),
        "product_id": random.choice(['product1', 'product2', 'product3']),
        "product_name": random.choice(['laptop', 'smartphone', 'tablet']),
        "product_category": random.choice(['electronics', 'clothing', 'books']),
        "product_price": round(random.randint(10, 1000), 2),
        "quantity": random.randint(1, 10),
        "brand": random.choice(['brand1', 'brand2', 'brand3']),
        "currency": random.choice(['USD', 'EUR', 'GBP']),
        "customer_id": user['username'],
        # "transaction_date": datetime.utcnow().strftime("%Y-%m-%d%H:%M:%S.%f%z"),
        "payment_method": random.choice(['credit_card', 'paypal', 'cash']),
    }


def delivery_report(err, msg):
    if err is not None:
        print(f"Delivery failed for message: {msg.value()}: {err.str()}")
        return
    print(f"Message produced: {msg.value()}")


def main():
    topic = "temp"
    producer = SerializingProducer({
        "bootstrap.servers": "localhost:9092",
    })

    curr_time = datetime.now()

    while (datetime.now() - curr_time).seconds <= 120:
        try:
            transaction = generate_sales_transactions()
            producer.produce(topic, key=transaction['transaction_id'], value=json.dumps(transaction),
                             on_delivery=delivery_report)
            producer.poll(0)

            producer.flush()

            time.sleep(1)
        except Exception as e:
            print(f"An error occurred: {e}")
            break


if __name__ == "__main__":
    main()
