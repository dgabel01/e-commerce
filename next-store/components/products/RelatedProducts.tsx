"use client";
import { useEffect, useState } from "react";
import medusa from "@/lib/medusa";
import Image from "next/image";
import { Product } from "@/types/productType";

export function RelatedProducts() {
  const [products, setProducts] = useState<Product[]>([]);

  const fixImageUrl = (url?: string) => {
    if (!url) return "";
    return url.replace("localhost:9000", "localhost:9001");
  };

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const { collections } = await medusa.collections.list({ handle: "related-products", limit: 1 });
        if (!collections?.length) return;

        const collectionId = collections[0].id;

        const { products } = await medusa.products.list({
          collection_id: collectionId,
        });

        setProducts(products);
      } catch (err) {
        console.error("Failed to fetch related products", err);
      }
    };

    fetchProducts();
  }, []);

  return (
    <section className="w-full max-w-6xl mx-auto px-4 py-16 mt-8">
      <h2 className="text-[48px] font-[500] mb-6">Related Products</h2>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {products.map((product) => (
          <div key={product.id} className="rounded p-4 flex flex-col gap-2">
            {product.thumbnail && (
              <div className="w-full h-48 relative mb-4">
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
                {product.variants?.[0]?.prices?.[0] && (
                  <p className="text-[#050505] font-[600] text-[16px]">
                    €{(product.variants[0].prices[0].amount / 100).toFixed(2)}
                  </p>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
