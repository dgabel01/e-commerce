import { useState, useEffect } from "react";
import medusa from "@/lib/medusa";
import { useCartStore } from "@/store/cartStore";
import toast from "react-hot-toast";
import { Product, Variant } from "@/types/productType";
import { COLORS } from "@/constants/colors";
import { fixImageUrl, getVariantPrice, getMaterialOptions } from "@/utils/productUtils";

export const useProductHero = (productId: string, regionId: string) => {
  const [product, setProduct] = useState<Product | null>(null);
  const [loading, setLoading] = useState(true);
  const [selectedVariant, setSelectedVariant] = useState<Variant | null>(null);
  const [quantity, setQuantity] = useState(1);
  const [selectedColor, setSelectedColor] = useState<string>("");
  const [adding, setAdding] = useState(false);

  const addItem = useCartStore((state) => state.addItem);

  useEffect(() => {
    const fetchProduct = async () => {
      try {
        setLoading(true);
        console.log("Fetching product with productId:", productId, "and regionId:", regionId);

        // Try with expand to include prices
        let res;
        try {
          res = (await medusa.products.retrieve(productId, {
            region_id: regionId,
            expand: "variants.prices",
          })) as unknown as { product: Product };
          console.log("API response with expand:", res);
        } catch (expandError) {
          console.warn("Expand failed, trying without expand:", expandError);
          res = (await medusa.products.retrieve(productId, {
            region_id: regionId,
          })) as unknown as { product: Product };
          console.log("API response without expand:", res);
        }

        console.log("Product:", res.product);
        console.log("Variants:", res.product?.variants);
        console.log("First Variant Prices:", res.product?.variants?.[0]?.prices);
        console.log("First Variant Calculated Price:", res.product?.variants?.[0]?.calculated_price);

        setProduct(res.product);
        if (res.product?.variants?.length) {
          setSelectedVariant(res.product.variants[0]);
        } else {
          console.warn("No variants found for product:", productId);
        }
      } catch (error) {
        console.error("Error fetching product:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchProduct();
  }, [productId, regionId]);

  useEffect(() => {
    if (selectedVariant) {
      const color = selectedVariant.options?.find((o) => o.option?.title === "Color")?.value;
      setSelectedColor(color || "");
    }
  }, [selectedVariant]);

  const handleMaterialChange = (material: string) => {
    if (!product) return;

    const currentColor = selectedColor;

    const newVariant = product.variants?.find((v) => {
      const variantMaterial = v.options?.find((o) => o.option?.title === "Material")?.value;
      const variantColor = v.options?.find((o) => o.option?.title === "Color")?.value;

      return (
        variantMaterial === material &&
        (!currentColor || variantColor === currentColor)
      );
    });

    if (newVariant) setSelectedVariant(newVariant);
  };

  const handleColorChange = (color: string) => {
    setSelectedColor(color);

    if (!product || !selectedVariant) return;

    const currentMaterial = selectedVariant.options?.find(
      (o) => o.option?.title === "Material"
    )?.value;

    const newVariant = product.variants?.find((v) => {
      const variantMaterial = v.options?.find((o) => o.option?.title === "Material")?.value;
      const variantColor = v.options?.find((o) => o.option?.title === "Color")?.value;

      return variantMaterial === currentMaterial && variantColor === color;
    });

    if (newVariant) setSelectedVariant(newVariant);
  };

  const handleAddToCart = async () => {
    if (!selectedVariant || !product) return;

    setAdding(true);
    await new Promise((resolve) => setTimeout(resolve, 1000)); // 1s delay

    const material = selectedVariant.options?.find((o) => o.option?.title === "Material")?.value;
    const color = selectedVariant.options?.find((o) => o.option?.title === "Color")?.value;

    const price = getVariantPrice(selectedVariant, regionId);
    if (!price) {
      console.warn("No price available for variant:", selectedVariant.id, "with regionId:", regionId);
      toast.error("Unable to add product: Price not available.", {
        duration: 3000,
      });
      setAdding(false);
      return;
    }

    addItem({
      variantId: selectedVariant.id,
      productId: product.id,
      title: product.title,
      price: Number(price),
      thumbnail: product.thumbnail || undefined,
      material,
      color,
      quantity,
    });

    toast.success(`${product.title} added to cart`, {
      icon: "✅",
      duration: 3000,
    });

    setQuantity(1);
    setAdding(false);
  };

  const currentMaterial =
    selectedVariant?.options?.find((o) => o.option?.title === "Material")?.value || "";

  const materialOptions = getMaterialOptions(product);

  const price = getVariantPrice(selectedVariant, regionId);

  const carouselImages = (product?.images || []).map((img, idx) => ({
    id: img.url ? img.url : `${product?.id ?? "unknown"}-img-${idx}`,
    url: fixImageUrl(img.url) ?? fixImageUrl(product?.thumbnail) ?? "",
  }));

  return {
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
  };
};