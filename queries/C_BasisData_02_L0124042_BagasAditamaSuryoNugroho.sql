CREATE DATABASE Perpustakaan;

USE Perpustakaan;

CREATE TABLE kategori (
    kategori_id INT PRIMARY KEY,
    nama_kategori VARCHAR(50),
    deskripsi TEXT
);

CREATE TABLE anggota (
    anggota_id INT PRIMARY KEY,
    nama VARCHAR(100),
    alamat TEXT,
    nomor_telepon VARCHAR(15),
    email VARCHAR(50),
    tanggal_bergabung DATE,
    tanggal_lahir DATE
);

CREATE TABLE petugas (
    petugas_id INT PRIMARY KEY,
    nama VARCHAR(100),
    position VARCHAR(50),
    nomor_telepon VARCHAR(15),
    email VARCHAR(50),
    tanggal_lahir DATE
);

CREATE TABLE buku (
    buku_id INT PRIMARY KEY,
    kategori_id INT,
    nama_buku VARCHAR(255),
    judul VARCHAR(255),
    penulis VARCHAR(100),
    penerbit VARCHAR(100),
    sinopsis TEXT,
    tahun_penerbitan INT,
    ISBN VARCHAR(20),
    jumlah_tersedia INT,
    FOREIGN KEY (kategori_id) REFERENCES kategori(kategori_id)
);

CREATE TABLE peminjaman (
    peminjaman_id INT PRIMARY KEY,
    anggota_id INT,
    buku_id INT,
    petugas_id INT,
    tanggal_peminjaman DATE,
    tanggal_pengembalian DATE,
    status VARCHAR(20),
    FOREIGN KEY (anggota_id) REFERENCES anggota(anggota_id),
    FOREIGN KEY (buku_id) REFERENCES buku(buku_id),
    FOREIGN KEY (petugas_id) REFERENCES petugas(petugas_id)
);

INSERT INTO kategori (kategori_id, nama_kategori, deskripsi) VALUES
(1, 'Fiksi', 'Buku-buku cerita rekaan atau novel'),
(2, 'Non-Fiksi', 'Buku-buku yang berdasarkan fakta'),
(3, 'Sains', 'Buku-buku ilmu pengetahuan'),
(4, 'Teknologi', 'Buku-buku mengenai teknologi'),
(5, 'Sejarah', 'Buku-buku sejarah dan peristiwa');

INSERT INTO anggota (anggota_id, nama, alamat, nomor_telepon, email, tanggal_bergabung, tanggal_lahir) VALUES
(1, 'Budi Santoso', 'Jl. Merdeka No. 10, Jakarta', '81234567890', 'budi@example.com', '2023-01-15', '1985-04-20'),
(2, 'Ani Wijaya', 'Jl. Sudirman No. 45, Bandung', '82345678901', 'ani@example.com', '2022-11-22', '1990-02-11'),
(3, 'Agus Pratama', 'Jl. Diponegoro No. 5, Surabaya', '83456789012', 'agus@example.com', '2021-07-30', '1988-09-15'),
(4, 'Siti Nurhaliza', 'Jl. Gatot Subroto No. 7, Medan', '84567890123', 'siti@example.com', '2020-03-18', '1995-12-05'),
(5, 'Dedi Kurniawan', 'Jl. Ahmad Yani No. 20, Yogyakarta', '85678901234', 'dedi@example.com', '2019-08-25', '1992-06-21');

INSERT INTO petugas (petugas_id, nama, position, nomor_telepon, email, tanggal_lahir) VALUES
(1, 'Rina Andriani', 'Kepala Perpustakaan', '81234567890', 'rina@example.com', '1980-03-15'),
(2, 'Toni Saputra', 'Pustakawan', '82345678901', 'toni@example.com', '1985-08-10'),
(3, 'Lina Kartika', 'Staf Administrasi', '83456789012', 'lina@example.com', '1990-12-01');

INSERT INTO buku (buku_id, kategori_id, nama_buku, judul, penulis, penerbit, sinopsis, tahun_penerbitan, ISBN, jumlah_tersedia) VALUES
(1, 1, 'Laskar Pelangi', 'Laskar Pelangi', 'Andrea Hirata', 'Bentang Pustaka', 'Kisah perjuangan anak-anak Melayu', 2005, '978-979-3062-79-4', 10),
(2, 2, 'Sapiens', 'Sapiens: Riwayat Singkat', 'Yuval Noah Harari', 'Gramedia Pustaka', 'Sejarah umat manusia dari awal', 2014, '978-602-03-1113-9', 5),
(3, 3, 'Cosmos', 'Cosmos', 'Carl Sagan', 'Random House', 'Eksplorasi tentang alam semesta', 1980, '978-0-394-50294-6', 7),
(4, 4, 'Clean Code', 'Clean Code', 'Robert C. Martin', 'Prentice Hall', 'Panduan praktik terbaik dalam coding', 2008, '978-0-13-235088-4', 3),
(5, 5, 'Sejarah Peradaban Dunia', 'Sejarah Peradaban Dunia', 'Will Durant', 'Simon & Schuster', 'Catatan sejarah dari berbagai peradaban', 1954, '978-0-671-52710-1', 8);

INSERT INTO peminjaman (peminjaman_id, anggota_id, buku_id, petugas_id, tanggal_peminjaman, tanggal_pengembalian, status) VALUES
(1, 1, 1, 2, '2024-01-01', '2024-01-15', 'Dipinjam'),
(2, 2, 3, 1, '2024-02-10', '2024-02-24', 'Dikembalikan'),
(3, 3, 2, 3, '2024-03-05', '2024-03-19', 'Dipinjam'),
(4, 4, 4, 2, '2024-04-12', '2024-04-26', 'Dikembalikan'),
(5, 5, 5, 1, '2024-05-20', '2024-06-03', 'Dipinjam');

SELECT * FROM kategori;
SELECT * FROM anggota;
SELECT * FROM petugas;
SELECT * FROM buku;
SELECT * FROM peminjaman;