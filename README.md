# array-map-gtm-template
Transform array elements (objects) into a new array of objects. 

## using the variable template
Create a new variable with this template. Choose a variable as input that holds an array or JSON object like "items" from event data or an extracted JSON string from a request parameter. Then define the desired structure of each of the elements of the new array.

## Example
If the input consists of the following array

```
[
    { quantity: 1, product: { id: 123546 }, name: "Product 1" }, 
    { quantity: 2, product: { id: 819234 }, name: "Product 2" },
]
```

and you need to transform that into a new array to conform to a particular API (such as TikTok): 

```
[
    { quantity: 1, content_id: "123546", content_name: "Product 1", content_type: "product_group" }, 
    { quantity: 2, content_id: "819234", content_name: "Product 2", content_type: "product_group" },
]
```

...you would set it up as follows:

Key | Value Path | Constant | Stringify the resulting value
--- | --- | --- | ---
quantity | quantity | false | false
content_id | product.id | false | true
content_name | name | false | false
content_type | product_group | true | false

