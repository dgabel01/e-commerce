"use client";

import Image from "next/image";
import dropdownIcon from "@/public/icons/chevron-down.svg";
import searchIcon from "@/public/icons/search_icon.svg";
import shoppingCartIcon from "@/public/icons/bag_icon.svg";
import { useCartStore } from "@/store/cartStore";
import { useState } from "react";

export default function Header() {
  const totalItems = useCartStore(
    (state) => state.items.reduce((total, item) => total + item.quantity, 0)
  );
  const clearCart = useCartStore((state) => state.clearCart);
  const [isCartOpen, setIsCartOpen] = useState(false);

  return (
    <header className="bg-base-100 shadow-sm h-[74px] w-full flex items-center justify-between px-4 lg:px-12">
      {/* Logo */}
      <div className="text-[24px] font-medium">SofaSocietyCo.</div>

      {/* Desktop Navigation */}
      <nav className="hidden lg:flex gap-8 items-center mx-auto">
        <a
          href="#"
          onClick={(e) => {
            e.preventDefault();
            clearCart();
          }}
        >
          About
        </a>
        <a href="#">Inspiration</a>
        <a href="#">Shop</a>
        <div className="flex items-center gap-1 cursor-pointer">
          <span>HR</span>
          <Image src={dropdownIcon} alt="Dropdown" width={24} height={24} />
        </div>
      </nav>

      {/* Desktop right icons */}
      <div className="hidden lg:flex items-center gap-4">
        <Image
          src={searchIcon}
          alt="Search"
          width={24}
          height={24}
          className="cursor-pointer"
        />
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

        {/* Hamburger */}
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

      {/* Cart Modal */}
      {isCartOpen && (
        <div className="fixed inset-0 bg-transparent backdrop-blur-md bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white p-6 rounded-lg w-full max-w-md">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-xl font-semibold">Your Cart</h3>
              <button
                onClick={() => setIsCartOpen(false)}
                className="text-gray-500 hover:text-gray-700"
              >
                Close
              </button>
            </div>
            <div className="space-y-4 max-h-[60vh] overflow-y-auto">
              {useCartStore.getState().items.length === 0 ? (
                <p className="text-center text-gray-500">Your cart is empty.</p>
              ) : (
                useCartStore.getState().items.map((item) => (
                  <div key={item.variantId} className="flex justify-between items-center">
                    <div>
                      <p className="font-medium">{item.title}</p>
                      <p className="text-sm text-gray-600">
                        Qty: {item.quantity} x €{item.price.toFixed(2)}
                      </p>
                      {item.material && (
                        <p className="text-sm text-gray-600">Material: {item.material}</p>
                      )}
                      {item.color && (
                        <p className="text-sm text-gray-600">Color: {item.color}</p>
                      )}
                    </div>
                    <p className="text-sm font-semibold">
                      €{(item.quantity * item.price).toFixed(2)}
                    </p>
                  </div>
                ))
              )}
            </div>
            {useCartStore.getState().items.length > 0 && (
              <div className="mt-6 text-right">
                <p className="text-lg font-semibold">
                  Total: €{
                    useCartStore
                      .getState()
                      .items.reduce(
                        (total, item) => total + item.quantity * item.price,
                        0
                      )
                      .toFixed(2)
                  }
                </p>
                <button
                  onClick={() => setIsCartOpen(false)}
                  className="mt-4 bg-black text-white px-4 py-2 rounded hover:bg-gray-800"
                >
                  Checkout
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </header>
  );
}