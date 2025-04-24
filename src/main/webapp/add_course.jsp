<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Course</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

<!-- Include Navbar -->
<jsp:include page="navbar.jsp"/>

<!-- Course Form Container -->
<div class="w-full px-12 py-6 sm:p-6 md:px-10 md:pb-40 md:pt-20 flex justify-center items-start">
    <div class="w-full max-w-lg bg-white p-4 sm:p-6 rounded shadow">
        <h2 class="text-xl sm:text-2xl font-bold text-gray-900">Add New Course</h2>
        <form action="uploadCourse" method="post" class="mt-4">
            <label class="block font-semibold text-gray-700">Course Title</label>
            <input type="text" name="title" class="w-full p-2 border rounded mt-1" required>

            <label class="block font-semibold mt-4 text-gray-700">Description</label>
            <textarea name="description" class="w-full p-2 border rounded mt-1 h-32" required></textarea>

            <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded mt-4 hover:bg-blue-600 transition w-full sm:w-auto">
                Upload Course
            </button>
        </form>
    </div>
</div>

<!-- Include Footer -->
<jsp:include page="footer.jsp"/>

</body>
</html>