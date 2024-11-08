import React, { useContext } from "react";
import { ShopContext } from "../context/context";
import data from "../data";
import { CartItem } from "./cart-item";
import { useNavigate } from "react-router-dom";

import "./cart.css";
export const Cart = () => {
  const { cartItems, getTotalCartAmount, checkout } = useContext(ShopContext);
  const totalAmount = getTotalCartAmount();

  const navigate = useNavigate();

  return (
    <div className="cart">
      <h1>Your Cart Items</h1>
      <div>
        
      </div>
      <div className="cartproducts">
        {data.map((product) => {
          if (cartItems[product.id] !== 0) {
            return <CartItem data={product} />;
          }
        })}
      </div>
      <div className="nextbox"> 
      {totalAmount > 0 ? (
        <div className="checkout">
          <h1><p> Subtotal: ${totalAmount} </p></h1>
          <button onClick={() => navigate("/")}> Continue Shopping </button>
          <button
            onClick={() => {
              checkout();
              navigate("/checkout");
            }}
          >
            {" "}
            Checkout{" "}
          </button>
        </div>
      ) : (
        <h1> Your Shopping Cart is Empty</h1>
      )}
      </div>
    </div>
  );
};