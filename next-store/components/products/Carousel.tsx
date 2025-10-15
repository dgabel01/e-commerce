"use client";

import * as React from "react";
import Image from "next/image";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
  type CarouselApi,
} from "@/components/ui/carousel";

import imageOne from "@/public/images/paloma_image_one.png";
import imageTwo from "@/public/images/paloma_image_one.png";

export function PeekCarousel() {
  const images = [imageOne, imageTwo];
  const [api, setApi] = React.useState<CarouselApi | undefined>();
  const [current, setCurrent] = React.useState(0);
  const [count, setCount] = React.useState(images.length);

  React.useEffect(() => {
    if (!api) return;

    setCount(api.scrollSnapList().length);
    setCurrent(api.selectedScrollSnap());

    const onSelect = () => setCurrent(api.selectedScrollSnap());
    api.on("select", onSelect);

    return () => {
      if (typeof api.off === "function") api.off("select", onSelect);
    };
  }, [api]);

  return (
   <div className="relative w-full max-w-xl mx-auto overflow-visible flex flex-col items-center">
  <Carousel
    setApi={setApi}
    opts={{ align: "start", loop: true }}
    orientation="horizontal"
    className="overflow-visible w-full"
  >
    <CarouselContent className="flex gap-0">
      {images.map((img, index) => (
        <CarouselItem
          key={index}
          className="flex-none w-[85%] mx-4 p-0 flex"
        >
          <div className="relative w-full h-[300px] md:h-[612px] flex-shrink-0">
            <Image
              src={img}
              alt={`Image ${index + 1}`}
              fill
              className="object-cover rounded"
            />
          </div>
        </CarouselItem>
      ))}
    </CarouselContent>

    {/* Arrows */}
    <CarouselPrevious className="absolute top-1/2 left-2 -translate-y-1/2 ..." aria-label="Previous">
      ←
    </CarouselPrevious>
    <CarouselNext className="absolute top-1/2 right-2 -translate-y-1/2 ..." aria-label="Next">
      →
    </CarouselNext>
  </Carousel>

  {/* Counter */}
  <div className="flex gap-6 mt-4">
    {Array.from({ length: count }).map((_, idx) => (
      <button
        key={idx}
        onClick={() => api?.scrollTo(idx)}
        className={idx === current ? "underline text-black" : "text-gray-400 hover:text-black"}
      >
        {idx + 1}
      </button>
    ))}
  </div>
</div>

  );
}
