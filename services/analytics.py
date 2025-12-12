from database.connection import get_connection


class AnalyticsService:
    @staticmethod
    def get_top_selling_products(limit=5):
        conn = get_connection()
        cursor = conn.get_cursor()
        query = """
        SELECT p.product_id, p.name, m.manufacturer_name,
               SUM(oi.quantity) as total_sold,
               SUM(oi.quantity * oi.unit_price) as total_revenue
        FROM orderitem oi
        JOIN product p ON oi.product_id = p.product_id
        LEFT JOIN manufacturer m ON p.manufacturer_id = m.manufacturer_id
        GROUP BY p.product_id, p.name, m.manufacturer_name
        ORDER BY total_sold DESC LIMIT %s;
        """
        cursor.execute(query, (limit,))
        result = cursor.fetchall()
        cursor.close()
        return result

    @staticmethod
    def get_sales_by_period(start_date, end_date):
        conn = get_connection()
        cursor = conn.get_cursor()
        query = """
        SELECT c.category_name,
               COUNT(DISTINCT o.order_id) as order_count,
               SUM(oi.quantity) as items_sold,
               SUM(oi.quantity * oi.unit_price) as total_revenue
        FROM "order" o
        JOIN orderitem oi ON o.order_id = oi.order_id
        JOIN product p ON oi.product_id = p.product_id
        LEFT JOIN category c ON p.category_id = c.category_id
        WHERE o.order_date BETWEEN %s AND %s
        GROUP BY c.category_name
        ORDER BY total_revenue DESC;
        """
        cursor.execute(query, (start_date, end_date))
        result = cursor.fetchall()
        cursor.close()
        return result