from database.connection import get_connection


class OrderDAO:
    @staticmethod
    def create_order(customer_id, employee_id, total_amount, status='new'):
        conn = get_connection()
        cursor = conn.get_cursor()
        cursor.execute(
            """INSERT INTO "Order" (customer_id, employee_id, total_amount, status) 
               VALUES (%s, %s, %s, %s) RETURNING order_id;""",
            (customer_id, employee_id, total_amount, status)
        )
        order_id = cursor.fetchone()['order_id']
        conn.commit()
        cursor.close()
        return order_id

    @staticmethod
    def add_product_to_order(order_id, product_id, quantity, unit_price):
        conn = get_connection()
        cursor = conn.get_cursor()
        cursor.execute(
            """INSERT INTO orderitem (order_id, product_id, quantity, unit_price) 
               VALUES (%s, %s, %s, %s);""",
            (order_id, product_id, quantity, unit_price)
        )
        conn.commit()
        cursor.close()
        return cursor.rowcount > 0

    @staticmethod
    def get_order_with_items(order_id):
        conn = get_connection()
        cursor = conn.get_cursor()
        cursor.execute("""
            SELECT o.order_id, o.order_date, o.total_amount, o.status,
                   c.full_name as customer_name,
                   p.name as product_name, oi.quantity, oi.unit_price
            FROM "Order" o
            JOIN customer c ON o.customer_id = c.customer_id
            LEFT JOIN orderitem oi ON o.order_id = oi.order_id
            LEFT JOIN product p ON oi.product_id = p.product_id
            WHERE o.order_id = %s;
        """, (order_id,))
        result = cursor.fetchall()
        cursor.close()
        return result