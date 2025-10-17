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

      // Fetch product with explicit relations
      const res = await medusa.products.retrieve(productId, {
        region_id: regionId,
        expand: "variants,variants.prices,variants.options,variants.options.option",
      });

      // Log raw response to inspect structure
      console.log("Raw API response:", JSON.stringify(res, null, 2));

      const product = res.product as Product;
      console.log("Parsed Product:", product);
      console.log("Variants:", product?.variants);
      console.log("First Variant:", product?.variants?.[0]);
      console.log("First Variant Prices:", product?.variants?.[0]?.prices);

      setProduct(product);
      if (product?.variants?.length) {
        setSelectedVariant(product.variants[0]);
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
    await new Promise((resolve) => setTimeout(resolve, 1000));

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