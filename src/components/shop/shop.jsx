import React from "react";
import data from "../data";
import { Product } from "./product";
import "./shop.css";
import introImage from '../../images/introimg.jpg';  // Import the image from src/images


export const Shop = () => {
  return (
    <div className="shop">
      <div className='intro' >
        

        <img src={introImage} alt="intro"className='introimg' />
        </div>
      <div className="shopTitle">
        
      </div>

      <div className="products">
        {data.map((product) => (
          <Product data={product} />
        ))}
      </div>
    </div>
  );
};