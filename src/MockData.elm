module MockData exposing (mockCategories, mockLibraryCategories)

import JellyfinAPI exposing (Category, MediaType(..), CastMember, CrewMember)

-- Mock categories (for main content)
mockCategories : List Category
mockCategories =
    [ { id = "continue-watching"
      , name = "Continue Watching"
      , items =
          [ { id = "show2"
            , title = "Chronicles of the Void"
            , type_ = TVShow
            , imageUrl = "show2.jpg"
            , year = 2021
            , rating = 8.7
            , description = Just "A thrilling sci-fi series about explorers who venture into a mysterious void at the edge of the universe."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Drama", "Mystery"]
            , cast =
                [ { id = "cast1", name = "Emma Stone", character = "Captain Sarah Chen", profileUrl = Nothing, order = 0 }
                , { id = "cast2", name = "John Boyega", character = "Dr. Marcus Wells", profileUrl = Nothing, order = 1 }
                , { id = "cast3", name = "Dev Patel", character = "Engineer Raj Kumar", profileUrl = Nothing, order = 2 }
                ]
            , directors =
                [ { id = "crew1", name = "Ava DuVernay", job = "Director", department = "Directing", profileUrl = Nothing }
                , { id = "crew2", name = "Christopher Nolan", job = "Executive Producer", department = "Production", profileUrl = Nothing }
                ]
            }
          , { id = "movie4"
            , title = "Nebula's Edge"
            , type_ = Movie
            , imageUrl = "movie4.jpg"
            , year = 2024
            , rating = 7.5
            , description = Just "When a team of scientists discovers a habitable planet at the edge of a distant nebula, they embark on a perilous journey only to find they are not alone."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Adventure", "Horror"]
            , cast =
                [ { id = "cast4", name = "Ryan Gosling", character = "Dr. Alex Harper", profileUrl = Nothing, order = 0 }
                , { id = "cast5", name = "Lupita Nyong'o", character = "Commander Maya Zhou", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew3", name = "Denis Villeneuve", job = "Director", department = "Directing", profileUrl = Nothing }
                ]
            }
          ]
      }
    , { id = "recently-added"
      , name = "Recently Added"
      , items =
          [ { id = "movie1"
            , title = "The Quantum Protocol"
            , type_ = Movie
            , imageUrl = "movie1.jpg"
            , year = 2023
            , rating = 8.5
            , description = Just "When a brilliant physicist discovers a way to manipulate time using quantum mechanics, governments and corporations race to control the technology."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Thriller", "Drama"]
            , cast =
                [ { id = "cast6", name = "Daniel Kaluuya", character = "Dr. James Wilson", profileUrl = Nothing, order = 0 }
                , { id = "cast7", name = "Florence Pugh", character = "Agent Elizabeth Bennett", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew4", name = "Bong Joon-ho", job = "Director", department = "Directing", profileUrl = Nothing }
                ]
            }
          , { id = "movie2"
            , title = "Echoes of Tomorrow"
            , type_ = Movie
            , imageUrl = "movie2.jpg"
            , year = 2024
            , rating = 7.8
            , description = Just "In a future where memories can be shared digitally, a memory detective uncovers a conspiracy that threatens global stability."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Mystery", "Thriller"]
            , cast =
                [ { id = "cast8", name = "Saoirse Ronan", character = "Memory Detective Eliza Grey", profileUrl = Nothing, order = 0 }
                , { id = "cast9", name = "Rami Malek", character = "Hacker Leo Chen", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew5", name = "Chloe Zhao", job = "Director", department = "Directing", profileUrl = Nothing }
                ]
            }
          , { id = "show1"
            , title = "Digital Horizons"
            , type_ = TVShow
            , imageUrl = "show1.jpg"
            , year = 2023
            , rating = 9.2
            , description = Just "An anthology series exploring the intersection of technology and humanity across different possible futures."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Drama", "Anthology"]
            , cast =
                [ { id = "cast10", name = "Anya Taylor-Joy", character = "Various Characters", profileUrl = Nothing, order = 0 }
                , { id = "cast11", name = "Anthony Mackie", character = "Various Characters", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew6", name = "Lana Wachowski", job = "Creator", department = "Production", profileUrl = Nothing }
                , { id = "crew7", name = "Alex Garland", job = "Director", department = "Directing", profileUrl = Nothing }
                ]
            }
          , { id = "movie3"
            , title = "Stellar Odyssey"
            , type_ = Movie
            , imageUrl = "movie3.jpg"
            , year = 2022
            , rating = 6.9
            , description = Just "The first human colony on Mars faces unexpected challenges when strange artifacts are discovered beneath the planet's surface."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Adventure"]
            , cast =
                [ { id = "cast12", name = "Oscar Isaac", character = "Commander Thomas Rivera", profileUrl = Nothing, order = 0 }
                , { id = "cast13", name = "Tessa Thompson", character = "Dr. Maya Patel", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew8", name = "James Gray", job = "Director", department = "Directing", profileUrl = Nothing }
                ]
            }
          ]
      }
    , { id = "recommended"
      , name = "Recommended For You"
      , items =
          [ { id = "movie5"
            , title = "Hypernova"
            , type_ = Movie
            , imageUrl = "movie5.jpg"
            , year = 2023
            , rating = 9.1
            , description = Just "As a nearby star threatens to go supernova, a specialized team of astronauts must embark on a mission to prevent catastrophe on Earth."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Action", "Drama"]
            , cast =
                [ { id = "cast14", name = "Keanu Reeves", character = "Commander Jack Harding", profileUrl = Nothing, order = 0 }
                , { id = "cast15", name = "Zendaya", character = "Astrophysicist Dr. Olivia Chen", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew9", name = "Patty Jenkins", job = "Director", department = "Directing", profileUrl = Nothing }
                ]
            }
          , { id = "show3"
            , title = "Temporal Divide"
            , type_ = TVShow
            , imageUrl = "show3.jpg"
            , year = 2022
            , rating = 8.4
            , description = Just "After a particle accelerator experiment goes wrong, reality splits into multiple timelines that begin to collide with devastating consequences."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Mystery", "Drama"]
            , cast =
                [ { id = "cast16", name = "Jonathan Majors", character = "Dr. Elijah Cross", profileUrl = Nothing, order = 0 }
                , { id = "cast17", name = "Jodie Comer", character = "Timeline Investigator Kate Wilson", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew10", name = "Noah Hawley", job = "Creator", department = "Production", profileUrl = Nothing }
                ]
            }
          , { id = "movie6"
            , title = "Parallel Essence"
            , type_ = Movie
            , imageUrl = "movie6.jpg"
            , year = 2024
            , rating = 7.2
            , description = Just "A woman discovers her doppelgänger from a parallel universe, leading to an identity crisis as she questions which reality is truly her own."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Psychological", "Drama"]
            , cast =
                [ { id = "cast18", name = "Brie Larson", character = "Emma/Alternate Emma", profileUrl = Nothing, order = 0 }
                , { id = "cast19", name = "LaKeith Stanfield", character = "Dr. Marcus Shaw", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew11", name = "Darren Aronofsky", job = "Director", department = "Directing", profileUrl = Nothing }
                ]
            }
          , { id = "show4"
            , title = "Quantum Nexus"
            , type_ = TVShow
            , imageUrl = "show4.jpg"
            , year = 2021
            , rating = 8.9
            , description = Just "A team of scientists working on quantum computing inadvertently open a gateway to alternate dimensions, unleashing chaos across the multiverse."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Adventure", "Action"]
            , cast =
                [ { id = "cast20", name = "John David Washington", character = "Dr. Robert Chen", profileUrl = Nothing, order = 0 }
                , { id = "cast21", name = "Cynthia Erivo", character = "Commander Diana Jackson", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew12", name = "The Wachowskis", job = "Creators", department = "Production", profileUrl = Nothing }
                ]
            }
          ]
      }
    ]

-- Mock library categories to replace sidebar navigation (fallback)
mockLibraryCategories : List Category
mockLibraryCategories =
    [ { id = "movie-library"
      , name = "Movies"
      , items =
          [ { id = "movie7"
            , title = "Cosmic Paradigm"
            , type_ = Movie
            , imageUrl = "movie7.jpg"
            , year = 2023
            , rating = 8.3
            , description = Just "A philosophical journey through the cosmos as an AI aboard an interstellar vessel contemplates the nature of existence."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Drama", "Philosophy"]
            , cast =
                [ { id = "cast22", name = "Steven Yeun", character = "Voice of IRIS AI", profileUrl = Nothing, order = 0 }
                , { id = "cast23", name = "Thomasin McKenzie", character = "Dr. Samantha Liu", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew13", name = "Richard Linklater", job = "Director", department = "Directing", profileUrl = Nothing }
                ]
            }
          , { id = "movie8"
            , title = "Neural Connection"
            , type_ = Movie
            , imageUrl = "movie8.jpg"
            , year = 2024
            , rating = 7.9
            , description = Just "Two strangers discover they share dreams and thoughts through an unexplained neural connection, leading them on a journey to find each other."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Romance", "Mystery"]
            , cast =
                [ { id = "cast24", name = "Paul Mescal", character = "Ethan Reed", profileUrl = Nothing, order = 0 }
                , { id = "cast25", name = "Daisy Edgar-Jones", character = "Lily Chen", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew14", name = "Greta Gerwig", job = "Director", department = "Directing", profileUrl = Nothing }
                ]
            }
          , { id = "movie9"
            , title = "Synthetic Dreams"
            , type_ = Movie
            , imageUrl = "movie9.jpg"
            , year = 2022
            , rating = 8.1
            , description = Just "In a world where dreams can be recorded and sold as entertainment, a dream detective investigates the theft of a prominent politician's subconscious."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Neo-Noir", "Mystery"]
            , cast =
                [ { id = "cast26", name = "Mahershala Ali", character = "Dream Detective Elias Cross", profileUrl = Nothing, order = 0 }
                , { id = "cast27", name = "Rebecca Ferguson", character = "Senator Victoria Palmer", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew15", name = "Rian Johnson", job = "Director", department = "Directing", profileUrl = Nothing }
                ]
            }
          , { id = "movie10"
            , title = "Digital Frontier"
            , type_ = Movie
            , imageUrl = "movie10.jpg"
            , year = 2023
            , rating = 7.6
            , description = Just "A team of data archaeologists explore the ruins of the Internet after a global cyber-catastrophe, discovering secrets that were meant to stay buried."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Adventure", "Mystery"]
            , cast =
                [ { id = "cast28", name = "Pedro Pascal", character = "Data Archaeologist Max Rivera", profileUrl = Nothing, order = 0 }
                , { id = "cast29", name = "Letitia Wright", character = "AI Specialist Dr. Amara Johnson", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew16", name = "Taika Waititi", job = "Director", department = "Directing", profileUrl = Nothing }
                ]
            }
          ]
      }
    , { id = "tv-library"
      , name = "TV Shows"
      , items =
          [ { id = "show5"
            , title = "Ethereal Connection"
            , type_ = TVShow
            , imageUrl = "show5.jpg"
            , year = 2022
            , rating = 8.8
            , description = Just "Humanity makes first contact with an alien intelligence that communicates through manipulating the fabric of reality itself."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Drama", "Mystery"]
            , cast =
                [ { id = "cast30", name = "Gemma Chan", character = "Dr. Lucy Chen", profileUrl = Nothing, order = 0 }
                , { id = "cast31", name = "David Oyelowo", character = "General Marcus Williams", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew17", name = "Denis Villeneuve", job = "Creator", department = "Production", profileUrl = Nothing }
                , { id = "crew18", name = "Nia DaCosta", job = "Director", department = "Directing", profileUrl = Nothing }
                ]
            }
          , { id = "show6"
            , title = "Parallel Futures"
            , type_ = TVShow
            , imageUrl = "show6.jpg"
            , year = 2023
            , rating = 9.0
            , description = Just "A secret government agency monitors timeline alterations and sends agents to prevent catastrophic changes to history."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Action", "History"]
            , cast =
                [ { id = "cast32", name = "Daniel Craig", character = "Agent Thomas Blake", profileUrl = Nothing, order = 0 }
                , { id = "cast33", name = "Janelle Monáe", character = "Director Nora Ellis", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew19", name = "Jonathan Nolan", job = "Creator", department = "Production", profileUrl = Nothing }
                , { id = "crew20", name = "Lisa Joy", job = "Creator", department = "Production", profileUrl = Nothing }
                ]
            }
          , { id = "show7"
            , title = "Quantum Horizon"
            , type_ = TVShow
            , imageUrl = "show7.jpg"
            , year = 2024
            , rating = 8.2
            , description = Just "After a particle accelerator accident, a physicist gains the ability to see and interact with quantum probability waves, allowing her to perceive possible futures."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Drama", "Thriller"]
            , cast =
                [ { id = "cast34", name = "Sonoya Mizuno", character = "Dr. Violet Chen", profileUrl = Nothing, order = 0 }
                , { id = "cast35", name = "Aldis Hodge", character = "FBI Agent Marcus Hill", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew21", name = "Sam Esmail", job = "Creator", department = "Production", profileUrl = Nothing }
                ]
            }
          , { id = "show8"
            , title = "Neural Network"
            , type_ = TVShow
            , imageUrl = "show8.jpg"
            , year = 2021
            , rating = 7.7
            , description = Just "In a near future where human minds can connect to a shared digital consciousness, a detective investigates murders taking place both in reality and the virtual world."
            , backdropUrl = Nothing
            , genres = ["Sci-Fi", "Crime", "Cyberpunk"]
            , cast =
                [ { id = "cast36", name = "John Cho", character = "Detective James Park", profileUrl = Nothing, order = 0 }
                , { id = "cast37", name = "Thandiwe Newton", character = "Dr. Eliza Ward", profileUrl = Nothing, order = 1 }
                ]
            , directors =
                [ { id = "crew22", name = "Lilly Wachowski", job = "Creator", department = "Production", profileUrl = Nothing }
                ]
            }
          ]
      }
    ]
