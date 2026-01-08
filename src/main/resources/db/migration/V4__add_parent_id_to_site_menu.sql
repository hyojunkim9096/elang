-- Add parent_id column to site_menu table for hierarchical menu structure
ALTER TABLE site_menu
ADD COLUMN parent_id BIGINT NULL AFTER menu_type;

-- Add index for performance
CREATE INDEX idx_site_menu_parent_id ON site_menu(parent_id);

-- Add foreign key constraint (optional, but recommended)
ALTER TABLE site_menu
ADD CONSTRAINT fk_site_menu_parent
FOREIGN KEY (parent_id) REFERENCES site_menu(id) ON DELETE CASCADE;
