"use client";
import React from "react";
import { useEffect, useState } from "react";
import medusa from "@/lib/medusa";
import Image from "next/image";
import { Product } from "@/types/productType";
import { fixImageUrl } from "@/utils/productUtils";

export default function ProductPage({ params }: { params: Promise<{ handle: string }> }) {
  const [product, setProduct] = useState<Product | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Unwrap params using React.use()
  const { handle } = React.use(params);

  useEffect(() => {
    const fetchProduct = async () => {
      try {
        setLoading(true);
        // Step 1: Fetch the related-products collection
        const { collections } = await medusa.collections.list({ handle: "related-products", limit: 1 });
        if (!collections.length) {
          throw new Error("Collection not found");
        }
        const collectionId = collections[0].id;

        // Step 2: Fetch products within the collection and find the one with the matching handle
        const { products } = await medusa.products.list({
          collection_id: collectionId,
          // Removed expand parameter due to 400 error
        });
        const matchedProduct = products.find((p: { handle: string; }) => p.handle === handle);
        if (!matchedProduct) {
          throw new Error("Product not found in collection");
        }
        setProduct(matchedProduct);
      } catch (err) {
        console.error("Failed to fetch product", err);
        setError("Product not found.");
      } finally {
        setLoading(false);
      }
    };

    fetchProduct();
  }, [handle]);

  if (loading) {
    return (
      <section className="w-full max-w-6xl mx-auto px-4 py-16">
        <div className="flex items-center justify-center h-96 text-gray-500">
          Loading...
        </div>
      </section>
    );
  }

  if (error || !product) {
    return (
      <section className="w-full max-w-6xl mx-auto px-4 py-16">
        <div className="flex items-center justify-center h-96 text-gray-500">
          {error || "Product not found."}
        </div>
      </section>
    );
  }

  return (
    <section className="w-full max-w-6xl mx-auto px-4 py-16 mt-8 overflow-x-hidden">
      <div className="flex flex-col items-center gap-8">
        {product.thumbnail && (
          <div className="w-full max-w-[492px] h-96 relative">
            <Image
              src={fixImageUrl(product.thumbnail)}
              alt={product.title}
              fill
              className="object-cover rounded-lg"
            />
          </div>
        )}
        <div className="w-full max-w-[492px] flex flex-col gap-4">
          <h3 className="font-[400] text-[24px]">{product.title}</h3>
          <p className="text-[#808080] text-[14px] font-[400]">{product.description}</p>
          {product.variants?.[0]?.prices?.[0] && (
            <p className="text-[#050505] font-[600] text-[20px]">
              €{(product.variants[0].prices[0].amount / 100).toFixed(2)}
            </p>
          )}
        </div>
      </div>
    </section>
  );
}