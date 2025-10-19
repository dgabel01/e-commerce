import { Product, Variant } from "@/types/productType";

export const fixImageUrl = (url: string | undefined) => {
  if (!url) return "";
  return url.replace("localhost:9000", "localhost:9001"); //Some process was running on 9000
};

export const getVariantPrice = (variant: Variant | null, regionId: string) => {
  if (!variant) return "0.00";
  const priceObj = variant.prices?.find((p) => p.region_id === regionId);
  return priceObj ? (priceObj.amount / 100).toFixed(2) : "0.00";
};

export const getMaterialOptions = (product: Product | null): string[] => {
  if (!product?.variants) return [];
  const materials = new Set(
    product.variants
      .map((v) => v.options?.find((o) => o.option?.title === "Material")?.value)
      .filter(Boolean)
  );
  return Array.from(materials) as string[];
};