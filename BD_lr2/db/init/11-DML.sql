INSERT INTO pet_breeds (pet_breed_description)
SELECT DISTINCT customer_pet_breed
FROM imported_mock_data;


INSERT INTO pet_types (pet_type_name)
SELECT DISTINCT customer_pet_type
FROM imported_mock_data;


INSERT INTO brands (brand_name)
SELECT DISTINCT product_brand
FROM public.imported_mock_data;


INSERT INTO colors (color_name)
SELECT DISTINCT product_color
FROM imported_mock_data;


INSERT INTO materials (material_name)
SELECT DISTINCT product_material
FROM imported_mock_data;


INSERT INTO product_categories (product_category_name)
SELECT DISTINCT product_category
FROM imported_mock_data;


INSERT INTO sizes (size_description)
SELECT DISTINCT product_size
FROM imported_mock_data;


INSERT INTO countries (country_name)
SELECT DISTINCT country
FROM(
	SELECT customer_country AS country FROM imported_mock_data
	UNION ALL
	SELECT seller_country FROM imported_mock_data
	UNION ALL
	SELECT store_country FROM imported_mock_data
	UNION ALL
	SELECT supplier_country FROM imported_mock_data
) AS all_countries;


INSERT INTO cities (city_name)
SELECT DISTINCT city
FROM (
	SELECT store_city as city FROM imported_mock_data
	UNION ALL
	SELECT supplier_city FROM imported_mock_data
) AS all_cities;


INSERT INTO supplier_names (supplier_name_description)
SELECT DISTINCT supplier_name
FROM imported_mock_data;


---------------------------------------------------------------------------------------------------------------


WITH ordered_customers AS (
	SELECT DISTINCT ON (stg.sale_customer_id)
		stg.sale_customer_id as customer_id,
		stg.customer_first_name as customer_first_name,
		stg.customer_last_name as customer_last_name,
		stg.customer_age as customer_age,
		stg.customer_email as customer_email,
		country.country_id as country_id,
		stg.customer_postal_code as customer_postal_code,
		pet_types.pet_type_id as pet_type_id,
		stg.customer_pet_name as customer_pet_name,
		pet_breeds.pet_breed_id as pet_breed_id,
		stg.sale_date as sale_date
	FROM imported_mock_data AS stg
		LEFT JOIN countries AS country ON stg.customer_country = country.country_name
		LEFT JOIN pet_types ON stg.customer_pet_type = pet_types.pet_type_name
		LEFT JOIN pet_breeds ON stg.customer_pet_breed = pet_breeds.pet_breed_description
	ORDER BY stg.sale_customer_id, stg.sale_date DESC
)
INSERT INTO customers (customer_id, customer_first_name, customer_last_name, customer_age, customer_email, customer_postal_code, customer_pet_name, customer_country_id, customer_pet_type_id, customer_pet_breed_id)
SELECT customer_id,
	customer_first_name,
	customer_last_name,
	customer_age,
	customer_email,
	customer_postal_code,
	customer_pet_name,
	country_id,
	pet_type_id,
	pet_breed_id
FROM ordered_customers;


WITH ordered_products AS (
	SELECT DISTINCT ON (stg.sale_product_id)
		stg.sale_product_id as product_id,
		stg.product_name as product_name,
		stg.product_price as product_price,
		cat.product_category_id as product_category_id,
		stg.product_weight as product_weight,
		col.color_id as product_color_id,
		siz.size_id as product_size_id,
		bra.brand_id as product_brand_id,
		mat.material_id as product_material_id,
		stg.product_description as product_description,
		stg.product_rating as product_rating,
		stg.product_reviews as product_reviews,
		stg.product_release_date as product_release_date,
		stg.product_expiry_date as product_expiry_date,
		stg.product_quantity as product_quantity
	FROM imported_mock_data AS stg
		LEFT JOIN product_categories AS cat ON stg.product_category = cat.product_category_name
		LEFT JOIN colors AS col ON stg.product_color = col.color_name
		LEFT JOIN sizes AS siz ON stg.product_size = siz.size_description
		LEFT JOIN brands AS bra ON stg.product_brand = bra.brand_name
		LEFT JOIN materials AS mat ON stg.product_material = mat.material_name
	ORDER BY stg.sale_product_id, stg.sale_date DESC
)
INSERT INTO products (product_id, product_name, product_price, product_category_id, product_weight, product_color_id, product_size_id, product_brand_id, product_material_id, product_description, product_rating, product_reviews, product_release_date, product_expiry_date, product_quantity)
SELECT product_id,
	product_name,
	product_price,
	product_category_id,
	product_weight,
	product_color_id,
	product_size_id,
	product_brand_id,
	product_material_id,
	product_description,
	product_rating,
	product_reviews,
	product_release_date,
	product_expiry_date,
	product_quantity
FROM ordered_products;


WITH ordered_sellers AS (
	SELECT DISTINCT ON (stg.sale_seller_id)
		stg.sale_seller_id as seller_id,
		stg.seller_first_name as seller_first_name,
		stg.seller_last_name as seller_last_name,
		stg.seller_email as seller_email,
		country.country_id as seller_country_id,
		stg.seller_postal_code as seller_postal_code,
		stg.sale_date as sale_date
	FROM imported_mock_data AS stg
		LEFT JOIN countries AS country ON stg.seller_country = country.country_name
	ORDER BY stg.sale_seller_id, stg.sale_date DESC
)
INSERT INTO sellers (seller_id, seller_first_name, seller_last_name, seller_email, seller_country_id, seller_postal_code)
SELECT seller_id,
	seller_first_name,
	seller_last_name,
	seller_email,
	seller_country_id,
	seller_postal_code
FROM ordered_sellers;


WITH ordered_stores AS (
	SELECT DISTINCT
		stg.store_name as store_name,
		stg.store_location as store_location,
		cit.city_id as store_city_id,
		stg.store_state as store_state,
		country.country_id as store_country_id,
		stg.store_phone as store_phone,
		stg.store_email as store_email,
		stg.sale_date as sale_date
	FROM imported_mock_data AS stg
		LEFT JOIN cities AS cit ON stg.store_city = cit.city_name
		LEFT JOIN countries AS country ON stg.store_country = country.country_name
	ORDER BY stg.sale_date DESC
)
INSERT INTO stores (store_name, store_location, store_city_id, store_state, store_country_id, store_phone, store_email)
SELECT store_name,
	store_location,
	store_city_id,
	store_state,
	store_country_id,
	store_phone,
	store_email
FROM ordered_stores;


INSERT INTO pet_categories (pet_category_name)
SELECT DISTINCT pet_category
FROM imported_mock_data;


WITH ordered_suppliers AS (
	SELECT DISTINCT
		stg.supplier_contact as supplier_contact,
		stg.supplier_email as supplier_email,
		stg.supplier_phone as supplier_phone,
		stg.supplier_address as supplier_address,
		city.city_id as supplier_city_id,
		country.country_id as supplier_country_id,
		name.supplier_name_id as supplier_name_id,
		stg.sale_date as sale_date
	FROM imported_mock_data AS stg
		LEFT JOIN cities AS city ON stg.supplier_city = city.city_name
		LEFT JOIN countries AS country ON stg.supplier_country = country.country_name
		LEFT JOIN supplier_names AS name ON stg.supplier_name = name.supplier_name_description
	ORDER BY stg.sale_date DESC
)
INSERT INTO suppliers (supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city_id, supplier_country_id, supplier_name_id)
SELECT supplier_contact,
	supplier_email,
	supplier_phone,
	supplier_address,
	supplier_city_id,
	supplier_country_id,
	supplier_name_id
FROM ordered_suppliers;


-----------------------------------------------------------------------------------------------------------------


WITH store_join AS (
	SELECT str.store_id as store_id,
		str.store_name as store_name,
		str.store_location as store_location,
		city.city_name as store_city,
		str.store_state as store_state,
		country.country_name as store_country,
		str.store_phone as store_phone,
		str.store_email as store_email
	FROM stores as str
		JOIN cities as city ON str.store_city_id = city.city_id
		JOIN countries as country ON str.store_country_id = country.country_id
	ORDER BY str.store_id
), supplier_join AS (
	SELECT sup.supplier_contact_id as supplier_contact_id,
		sup.supplier_contact as supplier_contact,
		sup.supplier_email as supplier_email,
		sup.supplier_phone as supplier_phone,
		sup.supplier_address as supplier_address,
		city.city_name as supplier_city,
		country.country_name as supplier_country,
		sup_nam.supplier_name_description as supplier_name
	FROM suppliers AS sup
		JOIN cities AS city ON sup.supplier_city_id = city.city_id
		JOIN countries AS country ON sup.supplier_country_id = country.country_id
		JOIN supplier_names AS sup_nam ON sup.supplier_name_id = sup_nam.supplier_name_id
	ORDER BY sup.supplier_contact_id
),ordered_sales AS (
	SELECT DISTINCT ON (stg.id)
		stg.id as sale_id,
		stg.sale_customer_id as sale_customer_id,
		stg.sale_seller_id as sale_seller_id,
		stg.sale_product_id as sale_product_id,
		stg.sale_quantity as sale_quantity,
		stg.sale_total_price as sale_total_price,
		store.store_id as sale_store_id,
		pet_cat.pet_category_id as sale_pet_category_id,
		supplier.supplier_contact_id as sale_supplier_contact_id,
		stg.sale_date as sale_date
	FROM imported_mock_data AS stg
		LEFT JOIN store_join AS store ON stg.store_name = store.store_name
			AND stg.store_location = store.store_location
			AND stg.store_city = store.store_city
			AND stg.store_state IS NOT DISTINCT FROM store.store_state
			AND stg.store_country = store.store_country
			AND stg.store_phone = store.store_phone
			AND stg.store_email = store.store_email
		LEFT JOIN pet_categories AS pet_cat ON stg.pet_category = pet_cat.pet_category_name
		LEFT JOIN supplier_join AS supplier ON stg.supplier_name = supplier.supplier_name
			AND stg.supplier_contact = supplier.supplier_contact
			AND stg.supplier_email = supplier.supplier_email
			AND stg.supplier_phone = supplier.supplier_phone
			AND stg.supplier_address = supplier.supplier_address
			AND stg.supplier_city = supplier.supplier_city
			AND stg.supplier_country = supplier.supplier_country
	ORDER BY stg.id, stg.sale_date DESC
)
INSERT INTO sales (sale_id, sale_customer_id, sale_seller_id, sale_product_id, sale_quantity, sale_total_price, sale_store_id, sale_pet_category_id, sale_supplier_contact_id, sale_date)
SELECT sale_id,
	sale_customer_id,
	sale_seller_id,
	sale_product_id,
	sale_quantity,
	sale_total_price,
	sale_store_id,
	sale_pet_category_id,
	sale_supplier_contact_id,
	sale_date
FROM ordered_sales