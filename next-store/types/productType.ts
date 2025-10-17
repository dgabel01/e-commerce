export interface Variant {
  id: string;
  options?: VariantOption[];
  prices?: Price[];
  calculated_price?: {
    calculated_amount: number;
    currency_code: string;
    raw_calculated_amount?: {
      value: string;
      precision: number;
    };
    is_calculated_price_price_list?: boolean;
    is_calculated_price_tax_inclusive?: boolean;
    original_amount?: number;
    raw_original_amount?: {
      value: string;
      precision: number;
    };
    is_original_price_price_list?: boolean;
    is_original_price_tax_inclusive?: boolean;
    calculated_price?: {
      id: string;
      price_list_id?: string | null;
      price_list_type?: string | null;
      min_quantity?: number | null;
      max_quantity?: number | null;
    };
    original_price?: {
      id: string;
      price_list_id?: string | null;
      price_list_type?: string | null;
      min_quantity?: number | null;
      max_quantity?: number | null;
    };
  };
}

export interface VariantOption {
  id: string;
  value: string;
  metadata?: Record<string, unknown> | null;
  option_id: string;
  option?: {
    id: string;
    title: string;
    metadata?: Record<string, unknown> | null;
    product_id: string;
    created_at: string;
    updated_at: string;
    deleted_at?: string | null;
  };
  created_at: string;
  updated_at: string;
  deleted_at?: string | null;
}

export interface Price {
  region_id: string;
  id: string;
  amount: number;
  currency_code: string;
}

export interface Product {
  id: string;
  title: string;
  handle: string;
  description?: string;
  thumbnail?: string;
  images?: Array<{ url?: string }>;
  collection?: { title?: string };
  variants?: Variant[];
}
