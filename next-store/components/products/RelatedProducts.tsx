"use client";

import { useEffect, useState } from "react";
import medusa from "@/lib/medusa";
import Image from "next/image";
import { Product } from "@/types/productType";
import { fixImageUrl } from "@/utils/productUtils";

export function RelatedProducts() {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        setLoading(true);
        const { collections } = await medusa.collections.list({ handle: "related-products", limit: 1 });
        if (!collections?.length) {
          console.warn("No collections found for handle: related-products");
          return;
        }

        const collectionId = collections[0].id;

        // Fetch products with region_id to include calculated prices
        const { products } = await medusa.products.list({
          collection_id: collectionId,
          region_id: "reg_01K7ES77EXHRJ5EH6TDSCEKES8", // Europe region
        });
        console.log("Fetched related products with variants:", products);

        // Debug each product's variants and calculated prices
        products.forEach((p: Product) => {
          console.log(`Product: ${p.title}, Variants:`, p.variants);
          console.log(`Product: ${p.title}, Calculated Price:`, p.variants?.[0]?.calculated_price);
        });

        setProducts(products);
      } catch (err) {
        console.error("Failed to fetch related products", err);
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, []);

  if (loading) {
    return (
      <section className="w-full max-w-6xl mx-auto px-4 py-16">
        <div className="flex items-center justify-center h-96 text-gray-500">
          Loading...
        </div>
      </section>
    );
  }

  if (!products || products.length === 0) {
    return (
      <section className="w-full max-w-6xl mx-auto px-4 py-16">
        <div className="flex items-center justify-center h-96 text-gray-500">
          Products not found, store error.
        </div>
      </section>
    );
  }

  return (
    <section className="w-full max-w-6xl mx-auto px-4 py-16 mt-8 overflow-x-hidden">
      <h2 className="text-[48px] font-[500] mb-6">Related Products</h2>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 max-w-full">
        {products.map((product) => (
          <div key={product.id} className="rounded p-4 flex flex-col gap-2 max-w-full">
            {product.thumbnail && (
              <div className="w-full h-48 relative mb-4 max-w-full">
                <Image
                  src={fixImageUrl(product.thumbnail)}
                  alt={product.title}
                  fill
                  className="object-cover rounded"
                />
              </div>
            )}
            <div className="flex flex-col gap-2">
              <h3 className="font-[400] text-[16px]">{product.title}</h3>
              <div className="flex justify-between items-start">
                <p className="text-[#808080] text-[12px] font-[400]">{product.description}</p>
                {product.variants?.[0]?.calculated_price?.calculated_amount ? (
                  <p className="text-[#050505] font-[600] text-[16px]">
                    €{(product.variants[0].calculated_price.calculated_amount)}
                  </p>
                ) : (
                  <p className="text-[#808080] text-[12px] font-[400]">Price unavailable</p>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}