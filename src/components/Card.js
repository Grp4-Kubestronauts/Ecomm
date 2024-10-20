import React from 'react'
import Data from '../components/data';
import '../css/card.css';

const Card = () => {
  return (
     <div>
     <h1>Our Products</h1>
               <div className='buy'>
                    {
                         Data.map( ({id,image,title, description, price}) => {
                                   return (
                                        <div key={id} className='boxes'>
                                             <div className='card'>

                                                  <div className='image'>
                                                   <img src ={image} width="200px"alt='Image missing' />
                                                  </div>

                                                  <div className='desc'>
                                                       <h1>{title}</h1>
                                                       <p>{description}</p>
                                                       <span>${price}</span>
                                                  </div>

                                                  <div className='star'>

                                                   </div>
                                             </div>
                                             <button className='btn'>Add To Cart</button>
                                        </div>
                                   )
                              
                              })    
                         }          
               </div>
               </div>
  )
}

export default Card