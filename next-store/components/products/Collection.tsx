import Image from "next/image";
import imageOne from "@/public/images/collection_image_one.png";
import imageTwo from "@/public/images/collection_image_two.png";
import imageThree from "@/public/images/collection_image_three.png";

export default function Collection() {
  return (
    <section className="bg-white mt-8">
      {/* Heading */}
      <h2 className="font-[500] text-[48px] md:text-[48px] leading-[140%] text-center lg:text-left p-8">
        Collection Inspired Interior
      </h2>

      <div className="flex flex-col gap-[80px]">

        {/* First Image */}
        <div className="px-4 lg:px-0">
          <div className="p-8 flex justify-center">
            <div className="w-full max-w-[1248px]">
              <Image
                src={imageOne}
                alt="Collection image 1"
                width={1248}
                height={702}
                className="w-full h-auto object-cover rounded-lg"
              />
            </div>
          </div>
        </div>

        {/* Second Image Fullscreen */}
        <div className="w-full">
          <Image
            src={imageTwo}
            alt="Collection image 2"
            width={1440}
            height={809}
            className="w-full h-auto object-cover"
          />
        </div>

        {/* Third Image and text*/}
        <div className="px-4 lg:px-0">
          <div className="p-8 flex flex-col lg:flex-row items-center lg:items-start gap-6">
            {/* Third Image */}
            <div className="w-full lg:w-[492px] mr-[32px]">
              <Image
                src={imageThree}
                alt="Collection image 3"
                width={492}
                height={656}
                className="w-full h-auto object-cover rounded-lg"
              />
            </div>

            {/* Text */}
            <div className="w-full lg:flex-1">
              <p className="font-[500] text-[48px] md:text-[48px] leading-[140%] mb-4">
                The Paloma Haven sofa is a masterpiece of minimalism and luxury.
              </p>
              <p className="underline text-[24px] font-normal">See more out of &apos;Modern Luxe&apos; collection</p>
            </div>
          </div>
        </div>

      </div>
    </section>
  );
}
