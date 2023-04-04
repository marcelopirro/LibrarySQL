# Project Name: Library Database System
The goal of this project is to create a database system to store information about the users, books, loans, and employees of a library.

## Entities
The following entities will be stored in the system:

### User
- Name
- Two phone numbers
- Address (street, street name, neighborhood, number, and zip code)
- CPF
- Unique identification code in the library (ID)
- Age (only users over 16 years old can register and borrow books)
- Marital status (single, married, widowed, divorced, or - separated)
- Gender (male, female, or other)

### Loan
- User
- Employee
- Book copy (one or more)
- Loan date
- Expected return date

### Employee
- Unique identification code in the library (ID)
- Name
- CPF
- Gender (male, female, or other)
- Age (only employees over 18 years old can be hired)
- Two phone numbers

### Book
- Title
- Publication year
- Total number of pages
- Number of copies
- ISBN (unique identifier)
- Category (science, sports, biography, history, science fiction, romance, suspense, fantasy, children, drama, poetry, religion, action and adventure, or other)
- Publisher
- Language (English, Portuguese, Spanish, or other)
- One or more authors

### Book Copy
- Partial identification code
- Conservation level (ranging from 0 to 5)

### Publisher
- CNPJ (unique identifier)
- Name
- Optional phone number
- Address (street, street name, neighborhood, number, and zip code)

### Author
- Name (unique identifier)
- Nationality (Brazilian, American, Canadian, German, French, Portuguese, Spanish, or other)
- At least one book


## Relationships
The following relationships exist between entities:

A loan occurs when there is a user, an employee, and at least one book copy.
A user can borrow several book copies at the same time.
A book can have several copies.
A book has only one publisher.
A publisher can have several books.
An author must have at least one book.

## Conclusion
With this database system, the library will be able to keep track of its users, books, loans, and employees, making it easier to manage its operations and provide better service to its patrons.