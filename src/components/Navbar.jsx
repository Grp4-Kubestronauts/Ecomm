import React from 'react'
import { Link } from "react-router-dom";


const Navbar = () =>{
    return(
        <div className='head_nav'>
            <div className='header'> 
                <a href="/">Kubestronauts</a> 
            </div>

            <nav className='navbar'> 
                <a href="/">Home</a>
                <a href="/about" >About</a>
                <a href="/services" >Services</a>
                <Link to='/cart' >Cart</Link>
                                   
            </nav>
         
        </div>
        
    )
}
export default Navbar