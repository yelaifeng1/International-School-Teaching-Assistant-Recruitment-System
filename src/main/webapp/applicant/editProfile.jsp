<form action="profile" method="post">
    StudentId: <input name="studentId" value="${applicant.studentId}"><br>
    Name: <input name="name" value="${applicant.name}"><br>
    Email: <input name="email" value="${applicant.email}"><br>
    Phone: <input name="phone" value="${applicant.phone}"><br>
    Skills: <textarea name="skills">${applicant.skills}</textarea><br>
    Availability: <input name="availability" value="${applicant.availability}"><br>
    <button type="submit">Save</button>
</form>