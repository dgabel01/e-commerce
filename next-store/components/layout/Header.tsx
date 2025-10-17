"use client";
import Image from "next/image";
import dropdownIcon from "@/public/icons/chevron-down.svg";
import searchIcon from "@/public/icons/search_icon.svg";
import shoppingCartIcon from "@/public/icons/bag_icon.svg";
import { useCartStore } from "@/store/cartStore";
import { useState } from "react";
import Link from "next/link";
import CartModal from "../cart/CartModal";

export default function Header() {
  const totalItems = useCartStore(
    (state) => state.items.reduce((total, item) => total + item.quantity, 0)
  );
  const clearCart = useCartStore((state) => state.clearCart);
  const [isCartOpen, setIsCartOpen] = useState(false);

  return (
    <header className="h-[84px] w-full flex items-center justify-between px-4 lg:px-12">
      {/* Logo */}
      <div className="text-[24px] font-medium">SofaSocietyCo.</div>

      {/* Desktop Navigation */}
      <nav className="hidden lg:flex gap-8 items-center">
        <Link
          href="#"
          className="font-normal text-[16px]"
          onClick={(e) => {
            e.preventDefault();
            clearCart();
          }}
        >
          About
        </Link>
        <Link href="#" className="font-normal text-[16px]">Inspiration</Link>
        <Link href="#" className="font-normal text-[16px]">Shop</Link>
      </nav>

      {/* Desktop right icons */}
      <div className="hidden lg:flex items-center gap-[32px]">
        <div className="flex items-center gap-1 cursor-pointer">
          <span>HR</span>
          <Image src={dropdownIcon} alt="Dropdown" width={24} height={24} />
        </div>
        <Image
          src={searchIcon}
          alt="Search"
          width={24}
          height={24}
          className="cursor-pointer"
        />
        <div className="relative cursor-pointer" onClick={() => setIsCartOpen(true)}>
          <Image src={shoppingCartIcon} alt="Cart" width={24} height={24} />
          {totalItems > 0 && (
            <span className="absolute -top-2 -right-2 bg-black text-white text-xs font-semibold rounded-full flex items-center justify-center w-[24px] h-[24px]">
              {totalItems}
            </span>
          )}
        </div>
      </div>

      {/* Mobile Navigation */}
      <div className="flex lg:hidden items-center gap-4">
        <div
          className="relative cursor-pointer"
          onClick={() => setIsCartOpen(true)}
        >
          <Image src={shoppingCartIcon} alt="Cart" width={24} height={24} />
          {totalItems > 0 && (
            <span className="absolute -top-2 -right-2 bg-black text-white text-xs font-semibold rounded-full w-5 h-5 flex items-center justify-center">
              {totalItems}
            </span>
          )}
        </div>

        {/* Hamburger Menu */}
        <div className="dropdown dropdown-end">
          <label tabIndex={0} className="btn btn-square btn-ghost p-0">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M4 6h16M4 12h16M4 18h16"
              />
            </svg>
          </label>
          <ul
            tabIndex={0}
            className="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52"
          >
            <li>
              <a
                href="#"
                onClick={(e) => {
                  e.preventDefault();
                  clearCart();
                }}
              >
                About
              </a>
            </li>
            <li><a href="#">Inspiration</a></li>
            <li><a href="#">Shop</a></li>
            <li><a href="#">HR</a></li>
          </ul>
        </div>
      </div>

      <CartModal isOpen={isCartOpen} onClose={() => setIsCartOpen(false)} />
    </header>
  );
}
