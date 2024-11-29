import React from 'react'


const Navbar = () =>{
    return(
        <div>
            <header className="header">
                <a href="/">Kubestronauts</a>
           
            <nav className='navbar'> 
                <a href="/">Home</a>
                <a href="/about" >About</a>
                <a href="/services" >Services</a>
                <a href="/contact" >Contact</a>
                                   
            </nav>
         </header>
        </div>
        
    )
}
export default Navbar