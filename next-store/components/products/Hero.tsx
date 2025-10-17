"use client";
import { useProductHero } from "@/hooks/useProductHero"; 
import { ProductGallery } from "./ProductGallery"; 
import { ProductDetails } from "./ProductDetails"; 
import { MaterialSelector } from "./MaterialSelector"; 
import { ColorSelector } from "./ColorSelector"; 
import { QuantitySelector } from "./QuantitySelector"; 
import { AddToCartButton } from "./AddToCartButton"; 

interface HeroProps {
  productId: string;
  regionId: string;
}

const Hero = ({ productId, regionId }: HeroProps) => {
  const {
    product,
    loading,
    selectedVariant,
    quantity,
    setQuantity,
    selectedColor,
    adding,
    currentMaterial,
    materialOptions,
    price,
    carouselImages,
    handleMaterialChange,
    handleColorChange,
    handleAddToCart,
    COLORS,
  } = useProductHero(productId, regionId);

  if (loading) {
    return (
      <section className="w-full max-w-6xl mx-auto px-4 py-16">
        <div className="flex items-center justify-center h-96 text-gray-500">
          Loading...
        </div>
      </section>
    );
  }

  if (!product || !selectedVariant) {
    return (
      <section className="w-full max-w-6xl mx-auto px-4 py-16">
        <div className="flex items-center justify-center h-96 text-gray-500">
          Product not found in store
        </div>
      </section>
    );
  }

  return (
    <section className="w-full max-w-6xl px-4 py-16 mx-auto">
      <div className="flex flex-col md:flex-row items-stretch gap-16">
        {/* LEFT */}
        <ProductGallery carouselImages={carouselImages} />

        {/* RIGHT */}
        <div className="w-full md:w-1/2 flex flex-col justify-between md:h-[612px]">
          <div>
            <ProductDetails product={product} price={price} />
            <MaterialSelector
              currentMaterial={currentMaterial}
              materialOptions={materialOptions}
              onChange={handleMaterialChange}
            />
            <ColorSelector
              selectedColor={selectedColor}
              onChange={handleColorChange}
              COLORS={COLORS}
            />
          </div>

          {/* Quantity & Add */}
          <div className="mt-6 flex flex-col md:flex-row items-center gap-4 w-full">
            <QuantitySelector quantity={quantity} setQuantity={setQuantity} />
            <AddToCartButton adding={adding} onClick={handleAddToCart} />
          </div>

          <p className="text-[16px] text-[#808080] mt-3 text-left">
            Estimated delivery 2-3 days
          </p>
        </div>
      </div>
    </section>
  );
};

export default Hero;