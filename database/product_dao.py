from database.connection import get_connection


class ProductDAO:
    @staticmethod
    def get_all():
        conn = get_connection()
        cursor = conn.get_cursor()
        query = """
        SELECT p.product_id, p.name, p.description, p.price,
               m.manufacturer_name, c.category_name
        FROM product p
        LEFT JOIN manufacturer m ON p.manufacturer_id = m.manufacturer_id
        LEFT JOIN category c ON p.category_id = c.category_id
        ORDER BY p.product_id;
        """
        cursor.execute(query)
        products = cursor.fetchall()
        cursor.close()
        return products

    @staticmethod
    def get_by_id(product_id):
        conn = get_connection()
        cursor = conn.get_cursor()
        query = """
        SELECT p.product_id, p.name, p.description, p.price,
               m.manufacturer_name, c.category_name,
               p.manufacturer_id, p.category_id
        FROM product p
        LEFT JOIN manufacturer m ON p.manufacturer_id = m.manufacturer_id
        LEFT JOIN category c ON p.category_id = c.category_id
        WHERE p.product_id = %s;
        """
        cursor.execute(query, (product_id,))
        product = cursor.fetchone()
        cursor.close()
        return product

    @staticmethod
    def create(name, description, price, manufacturer_id, category_id):
        conn = get_connection()
        cursor = conn.get_cursor()
        query = """
        INSERT INTO product (name, description, price, manufacturer_id, category_id)
        VALUES (%s, %s, %s, %s, %s) RETURNING product_id;
        """
        cursor.execute(query, (name, description, price, manufacturer_id, category_id))
        product_id = cursor.fetchone()['product_id']
        conn.commit()
        cursor.close()
        return product_id

    @staticmethod
    def update(product_id, name, description, price, manufacturer_id, category_id):
        conn = get_connection()
        cursor = conn.get_cursor()
        query = """
        UPDATE product SET name = %s, description = %s, price = %s,
                          manufacturer_id = %s, category_id = %s
        WHERE product_id = %s;
        """
        cursor.execute(query, (name, description, price, manufacturer_id, category_id, product_id))
        conn.commit()
        cursor.close()
        return cursor.rowcount > 0

    @staticmethod
    def delete(product_id):
        conn = get_connection()
        cursor = conn.get_cursor()
        query = "DELETE FROM product WHERE product_id = %s;"
        cursor.execute(query, (product_id,))
        conn.commit()
        cursor.close()
        return cursor.rowcount > 0