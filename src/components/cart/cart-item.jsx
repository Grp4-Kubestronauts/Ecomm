
import React, { useContext } from "react";
import { ShopContext } from "../context/context";
import "./cart.css";

export const CartItem = (props) => {
  const { id, title, price, image } = props.data;
  const { cartItems, addToCart, removeFromCart, updateCartItemCount } =
    useContext(ShopContext);

  return (
    <div classtitle="cartItem">
      <img className="cartimg" src={image} alt="img"/>
      <div classtitle="description">
        <p>
          <b>{title}</b>
        </p>
        <p> Price: ${price}</p>
        <div classtitle="countHandler">
          <button onClick={() => removeFromCart(id)}> - </button>
          <input
            value={cartItems[id]}
            onChange={(e) => updateCartItemCount(Number(e.target.value), id)}
          />
          <button onClick={() => addToCart(id)}> + </button>
        </div>
      </div>
    </div>
  );
};
