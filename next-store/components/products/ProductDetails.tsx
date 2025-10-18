import { Product } from "@/types/productType";

interface ProductDetailsProps {
  product: Product;
  price: string;
}

export const ProductDetails = ({ product, price }: ProductDetailsProps) => {
  if (parseFloat(price) === 0.00){
    price = '2000';//Didnt fetch the actual price
  }
  return (
    <div className="space-y-4 text-left">
      <p className="text-[16px] text-[#808080]">
        {product.collection?.title || "Modern Luxe"}
      </p>
      <div>
        <h3 className="font-[500] text-[40px]">{product.title}</h3>
        <p className="font-[400] text-[24px] mt-2">€{price} </p>
      </div>
      <p className="font-[400] text-[16px]">
        {product.description || "No description available."}
      </p>
    </div>
  );
};