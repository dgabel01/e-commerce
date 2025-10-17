import { PeekCarousel } from "./Carousel";

interface ProductGalleryProps {
  carouselImages: { id: string; url: string }[];
}

export const ProductGallery = ({ carouselImages }: ProductGalleryProps) => {
  return (
    <div className="w-full md:w-1/2 flex justify-center md:h-[612px]">
      <PeekCarousel images={carouselImages} />
    </div>
  );
};