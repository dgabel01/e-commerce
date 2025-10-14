//remove arrow on image
import Image from "next/image";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from "@/components/ui/carousel";

import imageOne from "@/public/images/paloma_image_one.png";
import imageTwo from "@/public/images/paloma_image_one.png";
import imageThree from "@/public/images/paloma_image_one.png";

export function PeekCarousel() {
  const images = [imageOne, imageTwo, imageThree];

  return (
    <div className="relative w-full max-w-xl mx-auto overflow-visible">
      <Carousel
        opts={{
          align: "start",
          loop: true,
        }}
        orientation="horizontal"
        className="overflow-visible"
      >
        <CarouselContent className="flex gap-4 -ml-4">
          {images.map((img, index) => (
            <CarouselItem key={index} className="flex-none w-[80%] p-0">
              <Image
                src={img}
                alt={`Image ${index + 1}`}
                className="object-cover rounded-none block"
                width={400}
                height={250}
              />
            </CarouselItem>
          ))}
        </CarouselContent>

        <CarouselPrevious className="absolute top-1/2 left-2 -translate-y-1/2 bg-white rounded-full p-2 shadow">
          ←
        </CarouselPrevious>
        <CarouselNext className="absolute top-1/2 right-2 -translate-y-1/2 bg-white rounded-full p-2 shadow">
          →
        </CarouselNext>
      </Carousel>
    </div>
  );
}
