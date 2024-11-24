  import React, { useContext } from "react";
  import { ShopContext } from "../context/context";

  export const Product = (props) => { 
    const { id, title, price, image } = props.data;
    const { addToCart, cartItems } = useContext(ShopContext);

    const cartItemCount = cartItems[id];

    return (
      <div className="product">
        <img src={image} alt="something" />
       
          <p><b>{title}</b></p>
          <p> $ {price}</p>
        <button className="addToCartBttn" onClick={() => addToCart(id)}>
          Add To Cart {cartItemCount > 0 && <> ({cartItemCount})</>}
        </button>
      </div>
    );
  };