-- ==========================================
-- ПРОЕКТ: Bookstore Sales Analysis
-- ИНСТРУМЕНТ: PostgreSQL
-- ОПИСАНИЕ: Аналитические запросы для расчета метрик
-- ==========================================

-- 1. Аудит: проверка общего количества строк
SELECT COUNT(*) AS total_rows FROM sales;

-- 2. Ключевые бизнес-метрики (KPI)
SELECT 
    SUM(quantity * unit_price_rub * (1 - discount_pct/100)) AS total_revenue,
    SUM(quantity) AS total_books_sold,
    COUNT(DISTINCT order_id) AS total_orders
FROM sales;

-- 3. Выручка только по успешно доставленным заказам (исключаем отмены и возвраты)
SELECT 
    SUM(quantity * unit_price_rub * (1 - discount_pct/100)) AS delivered_revenue
FROM sales
WHERE order_status = 'Доставлен';

-- 4. Топ-5 категорий по выручке
SELECT 
    category, 
    SUM(quantity * unit_price_rub * (1 - discount_pct/100)) AS revenue
FROM sales
GROUP BY category
ORDER BY revenue DESC
LIMIT 5;

-- 5. Категории с выручкой более 50 000 руб. (демонстрация HAVING)
SELECT 
    category, 
    SUM(quantity * unit_price_rub * (1 - discount_pct/100)) AS revenue
FROM sales
GROUP BY category
HAVING SUM(quantity * unit_price_rub * (1 - discount_pct/100)) > 50000
ORDER BY revenue DESC;

-- 6. Топ-5 городов по среднему чеку
SELECT 
    city, 
    ROUND(AVG(quantity * unit_price_rub * (1 - discount_pct/100)), 2) AS avg_check
FROM sales
GROUP BY city
ORDER BY avg_check DESC
LIMIT 5;

-- 7. Динамика выручки по месяцам
SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    SUM(quantity * unit_price_rub * (1 - discount_pct/100)) AS revenue
FROM sales
GROUP BY month
ORDER BY month;