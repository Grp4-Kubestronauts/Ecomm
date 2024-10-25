<<<<<<< HEAD
import './css/product.css';
import './App.css'

import introImage from './images/introimg.jpg';  // Import the image from src/images
import introImage2 from './images/introimg2.png';
import introImage3 from './images/introimg3.jpg'

import { Products } from './components/Products';
import Navbar from './components/Navbar';
import contents from './components/content'; 
import Footer from './components/footer';

=======
import logo from './logo.svg';
import './App.css';
>>>>>>> karthik

function App() {
  return (
    <div className="App">
<<<<<<< HEAD

       {/*This is for the NavBar/Menu component */} 
       <Navbar/>
     
      {/*This is for the image*/} 
      <div className='intro' >
        

      <img src={introImage} alt="intro"className='introimg' />
      </div>

      {/*This is for the Products component */} 
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
      </div>

      <Footer/>
      
=======
      <h1>Demo World!!!!!</h1>
>>>>>>> karthik
    </div>
  );
}

export default App;
