import './css/product.css';
import './App.css'



import Navbar from './components/Navbar';
import Footer from './components/footer';



import { Shop } from "./components/shop/shop";
import { Cart } from "./components/cart/cart";
import { ShopContextProvider } from "./components/context/context";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";



function App() {
  return (
    <div className="App">
      <ShopContextProvider>
      

      <Router>
      <Navbar />
       {/*This is for the image*/} 
       
          <Routes>
            <Route path="/" element={<Shop />} />
            <Route path="/cart" element={<Cart />} />
          </Routes>
        </Router>

    

      {/*This is for the Products component 
      <div className='App2s'>
            {contents.map((contents) => (
                <Products 
                    key={contents.id}
                    image={contents.image}
                    name={contents.name}
                    price={contents.price}
                    totalSales={contents.totalSales}
                    timeLeft={contents.timeLeft}
                    rating={contents.rating}
                />
            ))}
      </div>*/} 

      
      </ShopContextProvider>
      <Footer/>
      
    </div>
  );
}

export default App;
