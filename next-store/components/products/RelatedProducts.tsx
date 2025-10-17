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
        const { collections } = await medusa.collections.list({
          handle: "related-products",
          limit: 1,
        });
        if (!collections?.length) return;

        const collectionId = collections[0].id;

        const { products } = await medusa.products.list({
          collection_id: collectionId,
          region_id: "reg_01K7ES77EXHRJ5EH6TDSCEKES8", // Europe region
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
      <h2 className="text-[36px] md:text-[48px] font-[500] mb-6 leading-[140%]">
        Related Products
      </h2>

      <div className="grid grid-cols-2 md:grid-cols-3 gap-[16px] md:gap-[24px] max-w-full">
        {products.map((product) => {
          const isHiddenMobile = product.title.toLowerCase() === "sutton royale";
          const isOslo = product.title.toLowerCase() === "oslo drift";

          return (
            <div
              key={product.id}
              className={`rounded p-4 flex flex-col gap-2 max-w-full lg:w-[384px] lg:h-[353px] ${isHiddenMobile ? "hidden md:flex" : ""
                }`}
            >
              {product.thumbnail && (
                <div className="w-full h-40 md:h-48 relative mb-4 max-w-full">
                  <Image
                    src={fixImageUrl(product.thumbnail)}
                    alt={product.title}
                    fill
                    className="object-cover rounded"
                  />
                </div>
              )}

              <div className="flex flex-col gap-2 w-full">
                <div className="md:hidden">
                  <h3 className="font-[400] text-[14px] leading-[140%]">
                    {product.title}
                  </h3>

                  {isOslo ? (
                    <div className="flex justify-between items-baseline">
                      <p className="text-[#DF4718] font-[600] text-[14px]">€2000</p>
                      <p className="text-[#808080] text-[12px] line-through">€3000</p>
                    </div>
                  ) : (
                    <p className="text-[#050505] font-[600] text-[14px] leading-[140%]">
                      €
                      {product.variants?.[0]?.calculated_price?.calculated_amount ||
                        "N/A"}
                    </p>
                  )}
                </div>

                <div className="hidden md:flex flex-col gap-1">
                  {isOslo ? (
                    <>
                      <div className="flex justify-between items-baseline">
                        <h3 className="font-[400] text-[16px] leading-[140%]">
                          {product.title}
                        </h3>
                        <p className="text-[#DF4718] font-[600] text-[16px]">
                          €2000
                        </p>
                      </div>

                      <div className="flex justify-between items-baseline">
                        <p className="text-[#808080] text-[12px] font-[400] max-w-[70%]">
                          {product.description}
                        </p>
                        <p className="text-[#808080] text-[14px] font-[400] line-through">
                          €3000
                        </p>
                      </div>
                    </>
                  ) : (
                    <>
                      <div className="flex justify-between items-baseline">
                        <h3 className="font-[400] text-[16px] leading-[140%]">
                          {product.title}
                        </h3>
                        <p className="text-[#050505] font-[600] text-[16px] leading-[140%]">
                          €
                          {product.variants?.[0]?.calculated_price?.calculated_amount ||
                            "N/A"}
                        </p>
                      </div>

                      <p className="text-[#808080] text-[12px] font-[400] max-w-[80%]">
                        {product.description}
                      </p>
                    </>
                  )}
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </section>
  );
}
