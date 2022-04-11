--- Design Relational Database --- 
-- Order tracking database --

I use MySQL, XAMPP to build this database.
With the problem of Design a system to track where orders are shipped from. 

Problem: 
- Know that an order can be obtained from  multiple warehouses, then shipped by multiple shipping partners across multiple warehouses. 
- Users  can track where the order has gone and when they can receive the order. 

Requirements: 
Here are the requirements service: 
- User should be able to see what order is delivering to them 
- User should be able to see what product inside order 
- User should be able to see their location order 

 
-I created six tables to record the customer, warehouse, product, and track number information.
In it, I optimize the primary key and foreign key to create 1-to-1, 1-n links for normalization.

-The problem of goods being exported from multiple warehouses will be solved by the storehouse table.
The problem of shipping many goods, I use the shipping code to manage. That's why I have tracking_no in the order_detail table.
So in the order_details table I have product_id and customer_id 

-I used to manage an online shop selling paintings on the ESTY platform. 
Here we deal with a third party and WORLD to issue a Tracking code and customers can track their own goods.

-I also use this method to handle the request that the customer can know what product is being delivered.
So in the order_details table I have product_id and customer_id. 

-I avoid creating too much data by using two tables, order_id and order_details.

Ultimately, I think the point of giving customers the right to know what their goods are and where they're being shipped is to help the customer service staff not need to answer these questions. 
They will have the time and energy to do more.

Then we can go on to add features like automatically notifying customers about their ordered products. 
Extract data from the system to send mail, sms to help customers track orders themselves.

I know that this system is definitely flawed, but I did my best to create it. 
I thank the company for reading this line, hope my content will receive the company's response. Thank you