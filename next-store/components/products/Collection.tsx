import Image from "next/image";
import imageOne from "@/public/images/collection_image_one.png";
import imageTwo from "@/public/images/collection_image_two.png";
import imageThree from "@/public/images/collection_image_three.png";

export default function Collection() {
  return (
    <section className="bg-white mt-8 overflow-x-hidden">
      {/* Heading */}
      <h2 className="font-[500] text-[48px] md:text-[48px] leading-[140%] text-center lg:text-left p-8">
        Collection Inspired Interior
      </h2>

      <div className="flex flex-col gap-[80px]">
        {/* First Image */}
        <div className="px-4 lg:px-0">
          <div className="p-2 md:p-8 flex justify-center">
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

        {/* Second Image - same size & margin on mobile */}
        <div className="px-4 lg:px-0">
          <div className="p-2 md:p-0 flex justify-center">
            <div className="w-full max-w-[1248px]">
              <Image
                src={imageTwo}
                alt="Collection image 2"
                width={1248}
                height={702}
                className="w-full h-auto object-cover rounded-lg"
              />
            </div>
          </div>
        </div>

        {/* Third Image and Text */}
        <div className="px-4 lg:px-0">
          <div className="p-4 md:p-8 flex flex-col lg:flex-row items-start gap-6">
            {/* Third Image */}
            <div className="w-full lg:w-[492px] lg:h-[656px] max-w-full lg:ml-0">
              <Image
                src={imageThree}
                alt="Collection image 3"
                width={492}
                height={656}
                className="w-full h-auto object-cover rounded-lg"
              />
            </div>

            {/* Text */}
            <div className="w-full lg:flex-1 lg:ml-[64px] mr-2 mt-4 lg:mt-0">
              <p className="font-[500] text-[32px] md:text-[48px] leading-[140%] mb-4">
                The Paloma Haven sofa is a masterpiece of minimalism and luxury.
              </p>
              <p className="underline text-[20px] md:text-[24px] font-[400] leading-[140%] lg:w-[451px] lg:h-[34px]">
                See more out of &apos;Modern Luxe&apos; collection
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
