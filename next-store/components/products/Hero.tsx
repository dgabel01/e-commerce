"use client";
import { useState } from "react";
import { PeekCarousel } from "./Carousel";
import { COLORS } from "@/constants/colors";
import { MATERIALS } from "@/constants/materials";

const COLOR_MAP: { name: string; hex: string }[] = [
    { name: "Medium Gray", hex: COLORS.mediumGray },
    { name: "Dark Gray", hex: COLORS.darkGray },
    { name: "Light Gray", hex: COLORS.lightGray },
];

const Hero = () => {
    const [selectedColor, setSelectedColor] = useState(COLOR_MAP[0].hex);
    const [selectedMaterial, setSelectedMaterial] = useState(MATERIALS[0]);
    const [quantity, setQuantity] = useState(1);

    const dec = () => setQuantity((q) => Math.max(1, q - 1));
    const inc = () => setQuantity((q) => q + 1);

    return (
        <section className="w-full max-w-6xl mx-auto px-4 py-16 ">
            <div className="flex flex-col md:flex-row items-stretch gap-16">
                {/* LEFT: Carousel */}
                <div className="w-full md:w-1/2 flex justify-center md:h-[612px]">
                    <PeekCarousel />
                </div>

                {/* RIGHT: Product info */}
                <div className="w-full md:w-1/2 flex flex-col justify-between md:h-[612px]">
                    <div className="space-y-4 text-left">
                        <div className="text-[16px] font-[400] text-[#808080] leading-[140%]">
                            Modern Luxe
                        </div>

                        <div className="flex flex-col gap-4 leading-[140%]">
                            <h3 className="font-[500] text-[40px]">Paloma Haven</h3>
                            <p className="font-[400] text-[24px] mt-2">€12000</p>
                        </div>

                        <p className="font-[400] text-[16px] leading-[140%]">
                            Minimalistic designs, neutral colors, and high-quality textures.
                            Perfect for those who seek comfort with a clean and understated
                            aesthetic. This collection brings the essence of Scandinavian
                            elegance to your living room.
                        </p>

                        {/* Materials dropdown */}
                        <div className="flex flex-col items-center md:items-start gap-2 mt-12 leading-[140%]">
                            <div className="flex items-center gap-2">
                                <span className="font-[400] text-[16px]">Materials:</span>
                                <span className="font-[400] text-[16px] text-[#808080]">{selectedMaterial}</span>
                            </div>
                            <select
                                value={selectedMaterial}
                                onChange={(e) => setSelectedMaterial(e.target.value)}
                                className="w-full md:w-40 border rounded px-3 py-2 text-sm cursor-pointer text-center md:text-left"
                            >
                                {MATERIALS.map((mat) => (
                                    <option key={mat} value={mat}>
                                        {mat}
                                    </option>
                                ))}
                            </select>
                        </div>

                        {/* Color picker */}
                        <div className="flex flex-col items-start gap-2 mb-12 leading-[140%]">
                            <div className="flex items-center gap-2">
                                <span className="font-[400] text-[16px]">Colors:</span>
                                <span className="text-sm font-normal text-gray-800">
                                    {COLOR_MAP.find((c) => c.hex === selectedColor)?.name}
                                </span>
                            </div>
                            <div className="flex items-center gap-3">
                                {COLOR_MAP.map((c) => (
                                    <div key={c.hex} className="flex flex-col items-center">
                                        <button
                                            onClick={() => setSelectedColor(c.hex)}
                                            aria-label={c.name}
                                            title={c.name}
                                            className="w-8 h-8 rounded-sm border-2 border-gray-300 focus:outline-none focus:ring-2 focus:ring-offset-1"
                                            style={{ backgroundColor: c.hex }}
                                        />
                                        {selectedColor === c.hex && (
                                            <div className="w-6 h-1 bg-black mt-1 rounded" />
                                        )}
                                    </div>
                                ))}
                            </div>
                        </div>
                    </div>

                    {/* Quantity + Add to Cart */}
                    <div className="mt-6 flex flex-col md:flex-row items-center md:items-start gap-4 w-full leading-[140%]">
                        <div className="flex items-center border border-gray-300 rounded justify-center w-full md:w-auto">
                            <button
                                onClick={dec}
                                className="px-3 py-2 text-lg select-none"
                                aria-label="Decrease quantity"
                            >
                                -
                            </button>
                            <div className="px-4 py-2">{quantity}</div>
                            <button
                                onClick={inc}
                                className="px-3 py-2 text-lg select-none"
                                aria-label="Increase quantity"
                            >
                                +
                            </button>
                        </div>

                        <button className="w-full md:flex-1 lg:w-[388px] h-[48px] rounded-[4px] bg-black text-white hover:bg-gray-900 leading-[140%]">
                            Add to cart
                        </button>
                    </div>

                    <p className="text-[16px] text-[#808080] font-[400] mt-3 text-left leading-[140%]">Estimated delivery 2-3 days</p>
                </div>
            </div>
        </section>
    );
};

export default Hero;