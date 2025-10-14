import Image from "next/image";
import dropdownIcon from "@/public/icons/chevron-down.svg";
import searchIcon from "@/public/icons/search_icon.svg";
import shoppingCartIcon from "@/public/icons/bag_icon.svg";

export default function Header() {
  return (
    <div className="bg-base-100 shadow-sm h-[74px] relative">

      {/* Desktop Layout */}
      <div className="hidden lg:block w-full h-full relative">
        {/* Left Logo */}
        <div className="absolute left-[96px] top-1/2 transform -translate-y-1/2">
          <a className="text-[24px] font-medium leading-[90%] tracking-normal w-[175px] h-[22px]">
            SofaSocietyCo.
          </a>
        </div>

        {/* Center Nav */}
        <div className="absolute left-1/2 top-1/2 transform -translate-x-1/2 -translate-y-1/2">
          <div className="flex flex-row gap-[32px] text-[16px] font-normal leading-[140%] w-[229px] h-[22px]">
            <a>About</a>
            <a>Inspiration</a>
            <a>Shop</a>
          </div>
        </div>

        {/* Right Icons */}
        <div className="absolute right-[96px] top-1/2 transform -translate-y-1/2 flex items-center gap-[32px] w-[163px] h-[24px]">
          <div className="flex items-center gap-1 cursor-pointer">
            <span className="font-normal text-[16px] leading-[140%]">HR</span>
            <Image src={dropdownIcon} alt="Dropdown" width={24} height={24} />
          </div>
          <Image src={searchIcon} alt="Search" width={24} height={24} className="cursor-pointer" />
          <Image src={shoppingCartIcon} alt="Cart" width={24} height={24} className="cursor-pointer" />
        </div>
      </div>

      {/* Mobile Layout */}
      <div className="flex lg:hidden justify-between items-center px-4 h-full">
        {/* Left Logo */}
        <a className="text-[24px] font-medium leading-[90%] tracking-normal">
          SofaSocietyCo.
        </a>

        {/* Right: Bag + Hamburger */}
        <div className="flex items-center gap-2">
          <Image src={shoppingCartIcon} alt="Cart" width={24} height={24} className="cursor-pointer" />

          <div className="dropdown dropdown-end">
            <label
              tabIndex={0}
              className="btn btn-square btn-ghost no-animation hover:no-underline hover:bg-transparent hover:shadow-none p-0"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="inline-block h-6 w-6 stroke-current"
                fill="none"
                viewBox="0 0 24 24"
              >
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              </svg>
            </label>
            <ul
              tabIndex={0}
              className="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52"
            >
              <li><a>About</a></li>
              <li><a>Inspiration</a></li>
              <li><a>Shop</a></li>
              <li><a>HR</a></li>
            </ul>
          </div>
        </div>
      </div>

    </div>
  );
}
