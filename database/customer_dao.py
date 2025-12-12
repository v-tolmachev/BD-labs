from database.connection import get_connection


class CustomerDAO:
    @staticmethod
    def get_all():
        conn = get_connection()
        cursor = conn.get_cursor()
        query = "SELECT * FROM customer ORDER BY customer_id;"
        cursor.execute(query)
        customers = cursor.fetchall()
        cursor.close()
        return customers

    @staticmethod
    def get_with_orders(customer_id):
        conn = get_connection()
        cursor = conn.get_cursor()
        query = """
        SELECT c.customer_id, c.full_name, c.email, c.phone,
               o.order_id, o.order_date, o.total_amount, o.status
        FROM customer c
        LEFT JOIN "Order" o ON c.customer_id = o.customer_id
        WHERE c.customer_id = %s
        ORDER BY o.order_date DESC;
        """
        cursor.execute(query, (customer_id,))
        result = cursor.fetchall()
        cursor.close()
        return result

    @staticmethod
    def create(full_name, email, phone, address):
        conn = get_connection()
        cursor = conn.get_cursor()
        query = """
        INSERT INTO customer (full_name, email, phone, address)
        VALUES (%s, %s, %s, %s) RETURNING customer_id;
        """
        cursor.execute(query, (full_name, email, phone, address))
        customer_id = cursor.fetchone()['customer_id']
        conn.commit()
        cursor.close()
        return customer_id

    @staticmethod
    def update(customer_id, full_name, email, phone, address):
        conn = get_connection()
        cursor = conn.get_cursor()
        query = """
        UPDATE customer SET full_name = %s, email = %s,
                           phone = %s, address = %s
        WHERE customer_id = %s;
        """
        cursor.execute(query, (full_name, email, phone, address, customer_id))
        conn.commit()
        cursor.close()
        return cursor.rowcount > 0

    @staticmethod
    def delete(customer_id):
        conn = get_connection()
        cursor = conn.get_cursor()
        query = "DELETE FROM customer WHERE customer_id = %s;"
        cursor.execute(query, (customer_id,))
        conn.commit()
        cursor.close()
        return cursor.rowcount > 0