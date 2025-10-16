"use client";
import { useState, useEffect } from "react";
import { PeekCarousel } from "./Carousel";
import medusa from "@/lib/medusa";
import { useCartStore } from "@/store/cartStore";
import { COLORS } from "@/constants/colors";

interface HeroProps {
    productId: string;
    regionId: string;
}

interface Price {
    id?: string;
    region_id?: string;
    amount: number;
    currency_code?: string;
}

interface VariantOption {
    option?: { title?: string };
    value?: string;
}

interface Variant {
    id: string;
    options?: VariantOption[];
    prices?: Price[];
}

interface Product {
    id: string;
    title: string;
    description?: string;
    thumbnail?: string;
    images?: Array<{ url?: string }>;
    collection?: { title?: string };
    variants?: Variant[];
}

const Hero = ({ productId, regionId }: HeroProps) => {
    const [product, setProduct] = useState<Product | null>(null);
    const [loading, setLoading] = useState(true);
    const [selectedVariant, setSelectedVariant] = useState<Variant | null>(null);
    const [quantity, setQuantity] = useState(1);
    const [selectedColor, setSelectedColor] = useState<string>("");

    const addItem = useCartStore((state) => state.addItem);

    const fixImageUrl = (url: string | undefined) => {
        if (!url) return "";
        return url.replace("localhost:9000", "localhost:9001");
    };

    useEffect(() => {
        const fetchProduct = async () => {
            try {
                const res = (await medusa.products.retrieve(productId, {
                    region_id: regionId,
                    expand: "variants.options,images,collection,variants.prices",
                })) as unknown as { product: Product };

                setProduct(res.product);
                if (res.product?.variants?.length) {
                    setSelectedVariant(res.product.variants[0]);
                }
            } catch (error) {
                console.error("Error fetching product:", error);
            } finally {
                setLoading(false);
            }
        };

        fetchProduct();
    }, [productId, regionId]);

    // Sync selectedColor whenever selectedVariant changes
    useEffect(() => {
        if (selectedVariant) {
            const color = selectedVariant.options?.find(
                (o) => o.option?.title === "Color"
            )?.value;
            setSelectedColor(color || "");
        }
    }, [selectedVariant]);

    // Material options
    const getMaterialOptions = (): string[] => {
        if (!product?.variants) return [];
        const materials = new Set(
            product.variants
                .map((v) =>
                    v.options?.find((o) => o.option?.title === "Material")?.value
                )
                .filter(Boolean)
        );
        return Array.from(materials) as string[];
    };

    // Handle material change
    const handleMaterialChange = (material: string) => {
        if (!product) return;

        const currentColor = selectedColor;

        const newVariant = product.variants?.find((v) => {
            const variantMaterial = v.options?.find(
                (o) => o.option?.title === "Material"
            )?.value;
            const variantColor = v.options?.find(
                (o) => o.option?.title === "Color"
            )?.value;

            return variantMaterial === material && (!currentColor || variantColor === currentColor);
        });

        if (newVariant) setSelectedVariant(newVariant);
    };

    // Handle color change
    const handleColorChange = (color: string) => {
        setSelectedColor(color);

        if (!product || !selectedVariant) return;

        const currentMaterial = selectedVariant.options?.find(
            (o) => o.option?.title === "Material"
        )?.value;

        const newVariant = product.variants?.find((v) => {
            const variantMaterial = v.options?.find((o) => o.option?.title === "Material")?.value;
            const variantColor = v.options?.find((o) => o.option?.title === "Color")?.value;

            return variantMaterial === currentMaterial && variantColor?.toLowerCase() === color.toLowerCase();
        });

        if (newVariant) setSelectedVariant(newVariant);
    };

    const getVariantPrice = (variant: Variant) => {
        const priceObj = variant.prices?.find((p) => p.region_id === regionId);
        return priceObj ? (priceObj.amount / 100).toFixed(2) : "0.00";
    };

    const handleAddToCart = () => {
        if (!selectedVariant || !product) return;

        const material = selectedVariant.options?.find(
            (o) => o.option?.title === "Material"
        )?.value;
        const color = selectedVariant.options?.find(
            (o) => o.option?.title === "Color"
        )?.value;

        addItem({
            variantId: selectedVariant.id,
            productId: product.id,
            title: product.title,
            price: Number(getVariantPrice(selectedVariant)),
            thumbnail: product.thumbnail || undefined,
            material,
            color,
            quantity,
        });

        setQuantity(1);
    };

    const dec = () => setQuantity((q) => Math.max(1, q - 1));
    const inc = () => setQuantity((q) => q + 1);

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
                    Product not found
                </div>
            </section>
        );
    }

    const currentMaterial = selectedVariant.options?.find((o) => o.option?.title === "Material")?.value || "";
    const materialOptions = getMaterialOptions();
    const price = getVariantPrice(selectedVariant);
    const carouselImages = (product.images || []).map((img, idx) => ({
        id: img.url ? img.url : `${product.id}-img-${idx}`,
        url: fixImageUrl(img.url) ?? fixImageUrl(product.thumbnail) ?? "",
    }));

    return (
        <section className="w-full max-w-6xl mx-auto px-4 py-16">
            <div className="flex flex-col md:flex-row items-stretch gap-16">
                {/* LEFT */}
                <div className="w-full md:w-1/2 flex justify-center md:h-[612px]">
                    <PeekCarousel images={carouselImages} />
                </div>

                {/* RIGHT */}
                <div className="w-full md:w-1/2 flex flex-col justify-between md:h-[612px]">
                    <div className="space-y-4 text-left">
                        <p className="text-[16px] text-[#808080]">
                            {product.collection?.title || "Modern Luxe"}
                        </p>

                        <div>
                            <h3 className="font-[500] text-[40px]">{product.title}</h3>
                            <p className="font-[400] text-[24px] mt-2">€{price}</p>
                        </div>

                        <p className="font-[400] text-[16px]">
                            {product.description || "No description available."}
                        </p>

                        {/* Materials */}
                        {materialOptions.length > 0 && (
                            <div className="flex flex-col items-start gap-2 mt-8">
                                <div className="flex gap-2">
                                    <span>Materials:</span>
                                    <span className="text-[#808080]">{currentMaterial}</span>
                                </div>
                                <select
                                    value={currentMaterial}
                                    onChange={(e) => handleMaterialChange(e.target.value)}
                                    className="border rounded px-3 py-2 text-sm cursor-pointer"
                                >
                                    {materialOptions.map((mat) => (
                                        <option key={mat} value={mat}>
                                            {mat}
                                        </option>
                                    ))}
                                </select>
                            </div>
                        )}

                        {/* Colors */}
                        <div className="flex flex-col items-start gap-2 mt-8">
                            <div className="flex gap-2">
                                <span>Colors:</span>
                                <span className="text-[#808080]">{selectedColor || "—"}</span>
                            </div>

                            <div className="flex items-center gap-3 mt-1">
                                {Object.entries(COLORS).map(([name, hex]) => {
                                    const isSelected = selectedColor?.toLowerCase() === name.toLowerCase();
                                    return (
                                        <div key={name} className="flex flex-col items-center">
                                            <button
                                                onClick={() => handleColorChange(name)}
                                                aria-label={name}
                                                title={name}
                                                className={`w-8 h-8 rounded-sm border-2 focus:ring-2 focus:ring-offset-1 transition-colors ${
                                                    isSelected ? "border-black" : "border-gray-300"
                                                }`}
                                                style={{ backgroundColor: hex }}
                                            />
                                            {isSelected && <div className="w-6 h-1 bg-black mt-1 rounded" />}
                                        </div>
                                    );
                                })}
                            </div>
                        </div>
                    </div>

                    {/* Quantity & Add */}
                    <div className="mt-6 flex flex-col md:flex-row items-center gap-4 w-full">
                        <div className="flex items-center border border-gray-300 rounded">
                            <button onClick={dec} className="px-3 py-2 text-lg">
                                -
                            </button>
                            <div className="px-4 py-2">{quantity}</div>
                            <button onClick={inc} className="px-3 py-2 text-lg">
                                +
                            </button>
                        </div>

                        <button
                            onClick={handleAddToCart}
                            className="w-full md:flex-1 lg:w-[388px] h-[48px] rounded-[4px] bg-black text-white hover:bg-gray-900"
                        >
                            Add to cart
                        </button>
                    </div>

                    <p className="text-[16px] text-[#808080] mt-3 text-left">
                        Estimated delivery 2–3 days
                    </p>
                </div>
            </div>
        </section>
    );
};

export default Hero;
